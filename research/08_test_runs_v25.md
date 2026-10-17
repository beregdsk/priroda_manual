# Test runs on Priroda 25 (2025.02.28)

Three verification rounds: the inputs in `tests/inputs/`, run by the project owner with `tests/run.sh` on
2026-10-17 on one Linux machine (`node 0: 'arch'`), serial unless stated. Each round reran all earlier tests;
the outputs of rounds 1–3 were last in `tests/runs/20261017-124819/` (removed from the working tree in commit
`9332498`; still in git history, e.g. `git show ef39f62:tests/runs/20261017-124819/t01_energy.out`); round 4 is in
`tests/runs/20261017-130725/`. Energies were identical in every rerun. Banner: `Priroda 25 (2025.02.28)`, so the version number is **25**. The date matches the `p4_d` file on the
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

## Round 2

| Test | Result |
|---|---|
| stderr | Every run that stops on an input error (t06, t07a, t08, t22b) writes `application called MPI_Abort(MPI_COMM_WORLD, 1) - process 0` to stderr; for t08 (hybrid with `theory=dft`) that is the only message anywhere. |
| t21a | `p -np 2 input output` is not supported: the program takes `-np` as the input file name (`input file '-np'?.`, then `MPI_Abort`). t21b (bundled `mpiexec`) and t21c (`mpirun`) were not run: neither was available. |
| t22a | `$scf iterations=250 convergence=1e-7 $end` works (`conv = 1.0e-07`, `iter=250,16`). |
| t22b | `convergence=1e-7` and `iterations=250` on **separate lines** still fail with `unknown name terations`: a line break does not end the value list. |
| t22c | `$scf convergence=1e-7,1e-3 iterations=250 $end` works. So the problem is a **one-value** `convergence=` followed by another keyword; giving both values, or putting `convergence` last, avoids it. In round 1, `$optimize tol=1e-5 steps=100` (one-value list followed by a keyword) worked, so not every list keyword has this problem. |
| t23 | `&dft func=BLYP $end` is **silently ignored**: the run used PBE, no message. Groups must start with `$`. |
| t24 | Planar NH3 Hessian: one imaginary mode, printed with a trailing `i`: `\|    1 \|  845.22i\|   1.21 \| 357.748 \| …`. The thermochemistry table is still printed. |
| t25 | `$optimize saddle=1` with the t24 `$Energy` group (incl. `H=`) appended: echo `Saddle point search: follow = 1`, then `Lowest eigenvalues: -0.02919  0.18683` (the stored Hessian was read), `OPTIMIZATION CONVERGED in 1 steps!`; the final `MOL>` geometry stays planar (TS), E from -56.4876851 to -56.4877160. |
| t26 | `task=irc` with the t24 Hessian and `$optimize points=10`: header `Intrinsic Reaction Coordinate`, `n = 1, back = 0, down = 1`, `r = 0.1000000000`, the imaginary frequency and the mode. Each point is a constrained optimization (`Constrained Optimization for Path Point  N:`) and is printed as `IRC> point   N: distance = … E = … g = …` followed by an `IRC>`-prefixed `$molecule` group. Only one direction was followed. After 7 points (E -56.48769 to -56.49882, the minimum) it stopped with `Vicinity of a Stationary Point(?) --- STOP.` and printed the list of points again. |
| t27 | `save=t27.vec` writes the vectors; with `$guess read=1` the next run prints `Initial Guess (-1)` and `vectors from 't27.vec'` and converges in 1 iteration (5 in t27a). The normal guess is printed as `Initial Guess (2)`. |
| t28 | OH radical: with `iterations=100` the default Newton–Raphson SCF converges after 34 iterations (E = -75.6715198993); with `procedure=bfgs`, after 29 (E = -75.6715168582, 3·10⁻⁶ higher). |
| t29 | OH⁻ optimization: the `MOL>` block contains `MOL> charge=-1` but no `mult=` line. Together with t11 (no line for charge 0, mult 1): only values that differ from the defaults are written *(inferred)*. |
| t30a | `$molecule sym=1,0.01` alone: symmetry detected (`symmetry: C3v    6, unique:    2`) and the input geometry symmetrized, but the optimizer stays in internal coordinates with no symmetry lines, and the final structure is only approximately symmetric. |
| t30b | `$optimize sym=1` alone: `Coordinates: cartesian` and `symmetry: C1 (1)` at every step; no symmetry is used. So both options are needed: `$molecule sym=` detects and symmetrizes, `$optimize sym=1` keeps the symmetry during the optimization (t15). |
| t31 | `theory=ridft` without `$dft` uses `PBE1` (E = -76.3679713845, identical to an explicit `functional=PBE1`). |
| t32a | `task=hessian` with `ridft`/PBE1 works but is **numerical**: `NUMERICAL COMPUTATION OF SECOND DERIVATIVES`, one gradient per displacement (7 for water). |
| t32b | Same with `rimp2`: numerical, works. |
| t32c | `task=optimize` with `theory=hf` converges (4 steps): HF gradients work. |
| t33 | `theory=tddft`, `state=1,5`: `Time-Dependent Density Functional Theory for Excited States:`, Davidson-type iterations, the leading excitations per state, then `state N: E = <total>, DE = <excitation>, R = <transition moment x,y,z>` lines and an `Electronic Spectrum:` table (excitation energy in au and eV, wavelength in nm, transition moment in au, oscillator strength). Oscillator strengths are non-zero. `E  =` is the total energy of state 1 (the first value of `state=`). |
| t34 | `task=nmr` (DFT): `Calculation of NMR Chemical Shifts`, then `NMR Shielding Tensors:` (isotropic, principal values, tensor and principal axes per atom), then a list `isotropic= … shift= …` and the same sorted. Without `$nmr standard` the shift is minus the shielding. |
| t35 | `four=1` with `basis4.in`: `Finite nucleus model (1):` with Gaussian parameters per element, `Hamiltonian: scalar-relativistic`; E = -76.4207924482. So with `four=1` the nucleus defaults to finite. |
| t36 | `task=dipole`: `Numeric Evaluation of Dipole Polarizability`, 19 SCF runs in finite electric fields (water, 4.9 s); the results come as a `num>` block (with `Ax=` …), meant to be appended to a Hessian input *(inferred)*. |
| t37 | `task=scan` (adapted from the limor1 `NH3_scan-fix` input): echo `constrained variable: type=1 … value= 1.1, 1.1` and `type=3 … value= -180, -150`; one constrained optimization per point, each ending in `OPTIMIZATION CONVERGED`; then `Scan Structures:` with `SCAN> n= 0, s=0.000000, E= …` and an `SCAN>`-prefixed `$molecule` per point. `points=4` gives 4 points including both ends (s = 0, 1/3, 2/3, 1). |
| t38 | `theory=DFT_n4` with `functional=LPBEVV` runs (`DFT_N4`, `LPBEVV`, E = -76.3593590628); `ridft` with `LPBEVVV` runs (E = -76.3608742262). |
| t39 | `theory=qm_n3` with `basis=qm.in` (no `set=`): a much shorter output with no summary box: `qm file: '…/qm.in'`, `SCF: No=4,4 N=6 N1=17`, lines `it= N: E= … g= … x= …`, `converged!`, `e: -0.45857  0.32014` (HOMO and LUMO energies *(inferred)*), `gmax = …`. No `E  =` line. E = -76.2843068727 in 0.05 s. |
| t40 | `$optimize coordinated=1,1,2,0,0` with `task=energy`: no error. Inconclusive, because with `task=energy` the `$optimize` group may not be read at all. |

## Round 3

| Test | Result |
|---|---|
| t21 | Still not run: no bundled `mpiexec` and no `mpirun` on the test machine. |
| t40b | `$optimize coordinated=1,1,2,0,0` in a `task=optimize` run: `*** error in '$optimize' : unknown name coordinated`, exit 1. The `input.txt` spelling is a typo; the keyword is `coordinates`. |
| t40c | `$optimize nosuchkeyword=1` in a `task=energy` run: no error, normal energy. Groups the task does not read are not checked. |
| t41 | Planar NH3, `saddle=1`, two `$Energy` groups appended (first from t13, pyramidal geometry; then from t24, planar). `Lowest eigenvalues: -0.02919  0.18683`, identical to t25, so the **second** group was used. It was also the one matching the geometry, so "last wins" is not yet separated from "matching geometry wins". |
| t42 | IRC with `back=1`: `n = 1, back = 1, down = 1`, distances negative, same energies as t26 (the inversion path is symmetric), final N displaced to -z instead of +z. Ends with the same `Vicinity of a Stationary Point(?) --- STOP.` and lists the points in reverse. |
| t43 | Plain optimization from planar NH3 with the t24 Hessian appended: leaves the saddle point, `OPTIMIZATION CONVERGED in 19 steps!`, pyramidal final structure, E = -56.4988673129 (the minimum). |
| t44 | `$thermo sigma=3 temperature=200,298.15,400`: three tables (200.000, 298.150, 400.000 K). At 298.15 K, S = 46.0277 vs 48.2109 cal/(mol·K) without `sigma` (t13): difference 2.1832 = R ln 3. H unchanged, G shifted by T·ΔS. |
| t45 | `print=+vectors+molden`: 767 `mos>` lines with `[Molden Format]`, `[Atoms] AU`, `[5D]`, `[GTO]`, `[MO]`. The getting-started `grep`/`sed` recipe extracts them. Not opened in Molden. |
| t46 | `theory=tddft` with `functional=PBE1`: **runs**, summary box shows `TDDFT` and `PBE1`, exit 0, but the ground state lacks the exact exchange: `Ex = -6.61029772` (vs -8.954 with `ridft`/PBE1 and -8.950 with PBE), and the state-1 total energy is -73.876 (ground state about -74.145, i.e. about 2.2 hartree above PBE). The hybrid trap is still open for TDDFT. |
| t47 | `$molecule unit=b` with water in bohr: geometry echoed in Å as in t01, E = -76.3653914344 (t01: -76.3653913723; difference from rounding of the converted coordinates). |
| t48 | O2 `mult=3`: 9 alpha / 7 beta, beta orbitals printed (unrestricted although the electron count is even), converged, E = -150.2228124217. |
| t48b | O2 `mult=1`: closed shell, E = -150.1593089237, 0.0635 hartree above the triplet. |
| t49 | `basis4.in` without `four=1`: the output ends right after `Basis set input: '…/basis4.in'` with the single line `1?`; stderr `MPI_Abort`; exit 1. |

## Round 4

| Test | Result |
|---|---|
| t21a | Again `input file '-np'?.`: `p -np` is not supported. |
| t21b | `mpiexec -np 2 p in out` with the `mpiexec` from the official site works: `parallel on 2 processors`, one `node N:` line per process, E = -76.3653913723 (as serial). |
| t41b | Two `$Energy` groups with the planar Hessian first and the pyramidal one last: `Lowest eigenvalues:  0.03297  0.09355`, i.e. the **last** group is used. (With that wrong Hessian the saddle search then ran the full 128 steps without converging.) |
| t50 | `task=nosuchtask`: no message; the run sets up (geometry, basis, SCF and grid echo) and stops, exit 0, exactly like `task=check`. |
| t50b | `theory=nosuchtheory`: no error; the summary box says `NOSUCHTHEORY`, and the run does a **Hartree–Fock** calculation (E = -76.0503595209, identical to `theory=hf`). |
| t53 | `$control derivative=numeric` with `theory=dft`, `task=hessian`: `NUMERICAL COMPUTATION OF SECOND DERIVATIVES`; water frequencies 1572.30, 3895.20, 4006.43 cm⁻¹ (analytic, t56: 1572.29, 3895.05, …). |
| t55 | Split numerical Hessian (`ridft`, `$d2edr2 displace=1`): parts `steps=0,4` and `steps=5,9` each wrote 35 `num>` lines (5 SCF runs each); the combining run with `steps=-1` and both sets of lines appended did no SCF and printed the frequencies 1643.00, 3910.51, 4018.62 cm⁻¹ (one-run `ridft` Hessian with the default `displace=2`, 08 t32a: 1642.79, 3910.72, 4018.26). |
| t56 | Analytic DFT Hessian with the `num>` lines of `task=dipole` (t36) appended: Raman activities and depolarization ratios filled in (mode 1: 4.517, 0.3925; mode 2: 67.228, 0.1346). |
| t57a | `task=nmr` with `theory=ridft`: only the ground-state SCF; no shieldings, no message, exit 0. |
| t57b | `$nmr standard(1)=31.0 standard(8)=300.0`: `shift = standard − isotropic shielding` (H: 31.0 − 32.7773 = −1.7773; O: −36.8797). |

## Cosmetic

Every output ends with a repeated timing summary in which some lines show `0.0%` followed by a huge garbage number.
This is a display bug in the timing table *(inferred)* and does not affect results.
