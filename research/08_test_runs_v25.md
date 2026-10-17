# Test runs on Priroda 25 (2025.02.28)

First verification round: the inputs in `tests/inputs/`, run by the project owner with `tests/run.sh` on
2026-10-17 on one Linux machine (`node 0: 'arch'`), serial unless stated. Outputs are in
`tests/runs/20261017-121135/`. Banner: `Priroda 25 (2025.02.28)`, so the version number is **25**. The date matches the `p4_d` file on the
official site (`p` there is dated 2023-06-25); which file was run was not recorded.

Cite as `08 tNN`. This is program output, the top of the evidence order. Each result holds for v25 only; older
versions may differ. Items marked *(inferred)* are my reading of the output.

## Results by test

| Test | Result |
|---|---|
| t01 | Water PBE/L1 energy runs: `E = -76.3653913723`, `converged!` after 4 iterations. `task=energy` **does** print an `eng>` block (`E=` and dipole `D=`). `print=+bonds` prints `Overlap populations` (Mulliken charges) and `Bond orders`; `print=+charges` prints `Atomic partitions of the density` (Hirshfeld). `molecule input: ''` is printed in **every** run; it is not an error. |
| t02 | With no `task`, `theory` or `$system`: the run is `task=gradient` (gradient printed, `G=` in `eng>`, `G(max)`), `theory=dft`, functional PBE. Memory echo `Memory: 256m + 512m (256m + 512m)` and no `Disk:` line, i.e. *(inferred, from the echo format)* `memory=256` and a 512 MB RAM disk (`disk=-512`) per process. |
| t01/t02 | Default echo lines: `scf: conv = 1.0e-06, 1.0e-03; iter=32,16`; `grid: accuracy=1.0e-08,1.0e-05`. So `$scf iterations` defaults to **32,16** in v25 (not 16,16 as in v6–v15). |
| t01 | With `$system mem=128 disk=1` and no `path=`: `Disk:   1g '/tmp'`. Whether `TMPDIR` was set in the environment was not recorded. |
| t03 | `basis=basis.in` (relative) works when the file is in the current directory, which was also the input-file directory, so the two cases are not distinguished. |
| t04 | Two groups on one line (`$scf conv=1e-7,1e-3 $end $grid acc=1e-9 $end`) work: both values are echoed. |
| t05 | A line of text before the first group and a disabled group (`integral dir=1 $end`, no `$`) are ignored; the result equals t01 exactly. |
| t06 | Unknown keyword: output ends with `*** error in '$scf' : unknown name nosuchkeyword` right after the basis echo; exit status 1. |
| t07a | `$scf convergence=1e-7 iterations=250 $end` fails: `*** error in '$scf' : unknown name terations`; exit status 1. The value list after `convergence=` swallows the first letter of the next keyword *(inferred)*. Forum reports had `erations`. |
| t07b | `$scf convergence=1e-7 procedure=bfgs iterations=250 $end` works: `conv = 1.0e-07`, `iter=250,16`. BFGS changes the iteration table (no micro-iterations, an `x` column on every line), so `procedure=bfgs` took effect. |
| t08 | `theory=dft` with `functional=PBE1`: the output stops after the second basis echo, with **no error message** in the output; exit status 1. (stderr was not captured.) |
| t09 | Atomic numbers written as `8.0`, `1.0`: **no error**. The atom block is read as a stream of numbers; the integer read stops at `.`, the rest shifts, and the run continues with 4 atoms (O plus three `?` atoms with Z=0 and no basis functions), 8 electrons, formula `__3O`, and a meaningless energy (`-74.77`). Exit status 0. Z=0 atoms carry no basis functions, so they are not ghost atoms. |
| t10 | OH radical, `mult=2`: 5 alpha and 4 beta electrons, so `mult` is 2S+1. The SCF did **not** converge within the default 32 iterations (`no convergence!`), yet the run printed `E =`, the orbitals and properties, and exited with status 0. |
| t11 | NH3 optimization (`tol=1e-5 steps=100`) converges: `OPTIMIZATION CONVERGED in 6 steps!`. Each step prints a `mol>` block (lower case) with the next geometry; the final geometry is a `MOL>` block followed by `MOL> Energy = …`. Echo: `Coordinates: internal`, `Tolerance on gradient = 0.00001`, `Tolerance on displacement = 0.001`, `Trust radius = 0.125 (max), 0.015625 (min)`. |
| t12 | Optimization stopped by `steps=2`: no "not converged" message; the last geometry appears only as a `mol>` block (no `MOL>`). Defaults echoed: tolerance `0.0001` / `0.01`, trust `0.125` / `0.015625`. |
| t14 | Default `Maximum number of steps = 128` (no `steps=` given). `task=optimize+hessian` works: optimization, then `ANALYTICAL COMPUTATION OF SECOND DERIVATIVES` and the full thermochemistry. |
| t13 | Analytic Hessian (PBE): heading `ANALYTIC SECOND DERIVATIVES OF SCF ENERGY`; `eng>` gains `A=` (polarizability), `Dx=` and `H=` (packed Hessian). Then `Dipole Polarizability`, a table `Harmonic Frequencies (cm^-1), Reduced Masses (amu), IR Intensities (km/mol), Raman …` (Raman columns zero), `Normal Modes (mass-weighted) and Frequencies (cm^-1)`, `E = … E0 = …`, `ZPVE = 0.033524 a.u. = 21.0366 kcal/mol`, and the thermochemistry table at `T = 298.150 K` with rows translational/rotational/vibrational/total and columns ln(Q), S, U, H, G. `print=+molden` gives `freq>` lines in Molden format. No imaginary frequencies occurred, so their format is still unknown. |
| t13 | Rotational symmetry number is **not** detected: total S = 48.21 cal/(mol·K) for NH3, which exceeds the σ=3 value by R ln 3 = 2.18 *(inferred: σ=1 used)*. No symmetry number is printed. Give `$thermo sigma=` yourself. |
| t15 | `$molecule sym=1,0.01` with `$optimize sym=1` (NH3): `symmetry: C3v    6, unique:    2, d = 0.00028393` after reading the molecule; the input geometry is echoed symmetrized as `<$molecule` Cartesian lines. The optimizer reports `Coordinates: cartesian` and `symmetry: C3v (6)` at each step; the final `MOL>` Z-matrix is exactly symmetric and is followed by `MOL> symmetry: C3v`. Which of the two `sym=` options does what was not separated. |
| t16 | RI-MP2 with the default core: `atom 8 core = 1`, `Number of core electrons 1`; with `$atoms core(80)=0,0,0,0` the `core` line disappears and the count is 0, and E2 changes. So the index is 10·Z. The "Number of core electrons" line counts core *orbitals* (1 for O 1s) *(inferred)*. |
| t17 | Energies for water run to completion with `theory=` `hf`, `rihf`, `cis`, `mp2`, `mp3`, `mp4dq`, `mp4sdq`, `mp4sdtq`, `ccs`, `ccd`, `ccsd`, `ccsd4t` (exit 0 each). `ccs` returns the HF energy. `cis` prints a table of 6 states (total energy, excitation energy, wavelength, transition moment) and reports the first excited state's total energy as `E =`. Conventional `mp2` E2 = -0.2172421 vs RI-MP2 -0.2171040. |
| t18 | `task=check` stops after the setup (geometry, basis, SCF and grid settings); no SCF. |
| t19 | An output file name with capital letters (`T19_Capital.out`) works; no complaint. |
| t20 | `p input` with no output file writes the output to standard output. |
| t21a | `p -np 2 input output` failed: exit status 1 and no output file. stderr was not captured, and the bundled `mpiexec` was not next to `p`, so t21b did not run. Parallel launch is still open. |

## Cosmetic

Every output ends with a repeated timing summary in which some lines show `0.0%` followed by a huge garbage number.
This is a display bug in the timing table *(inferred)* and does not affect results.
