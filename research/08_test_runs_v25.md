# Test runs on Priroda 25 (2025.02.28)

Three verification rounds: the inputs in `tests/inputs/`, run by the project owner with `tests/run.sh` on
2026-10-17 on one Linux machine (`node 0: 'arch'`), serial unless stated. Each round reran all earlier tests;
each round's outputs replaced the previous ones in `tests/runs/`; older rounds are in git history:

- rounds 1–3: `git show ef39f62:tests/runs/20261017-124819/<file>`;
- round 4: `git show f04d4f5:tests/runs/20261017-130725/<file>`;
- round 5: `git show 192f430:tests/runs/20261017-131420/<file>`;
- round 6: `git show 7d6391c:tests/runs/20261017-131753/<file>`;
- round 7: `git show 705f5ab:tests/runs/20261017-133258/<file>`;
- round 8: `tests/runs/20261017-135441/` (first t72, stopped by the 1-hour limit: `tests/runs/20261017-141203/`);
- round 9: `tests/runs/20261017-152445/` (t71b, t74); t72 on 8 processes: `tests/runs/20261017-153851/` (an interrupted attempt is in `20261017-153621/`);
- round 10: `tests/runs/20261017-174656/` (t74a–c);
- round 11: `tests/runs/20261017-180916/` (t74a–e); `20261017-180746/` is an earlier run of t74a–c only, with the same energies.

Energies were identical in every rerun. Banner: `Priroda 25 (2025.02.28)`, so the version number is **25**. The date matches the `p4_d` file on the
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

## Round 5

| Test | Result |
|---|---|
| t58a | The first Input syntax example as printed (`$system mem=512 disk=-512 path=/tmp`): echo `Memory: 512m + 512m (512m + 512m)`, no `Disk:` line; `OPTIMIZATION CONVERGED in 6 steps!`, same final energy as t11. |
| t58b | `$molecule charge=0 mult=1 cartesian` on one line: read correctly, E as t01. |
| t59 | Relative `basis=basis.in` in a 2-process run (`mpiexec -np 2`): works, E as t01. |
| t60a | Singlet O2, `theory=dft` (PBE), `restrict=0`, `$guess mix=1`: converged to the restricted solution; alpha and beta orbital energies identical, E = -150.1593089237 = closed-shell t48b. |
| t60b | Same with `ridft`/PBE1: also identical alpha and beta orbital energies, E = -150.1410585415. The forum report that RI-DFT breaks the symmetry is not reproduced for O2. |
| t61 | `$system mem=2`: stops after the basis echo with `need 12544 + 7905408 = 7917952 bytes.`; stderr `MPI_Abort`; exit 1. |
| t62 | Conventional MP2 with `disk=-1` (1 MB RAM disk): stops in the grid setup with `0: out of disk space (grid_W), 8213824`; exit 1. |
| t63 | Numerical `ridft` Hessian on 2 processes: frequencies identical to the serial run (t32a), REAL time 4.85 s vs 7.17 s. The output also contains a `NUMERICAL AND ANALYTICAL GRADIENT` comparison block. |

## Round 6

| Test | Result |
|---|---|
| t64a | `$system mem=256 disk=1`, no `path=`, `TMPDIR` unset, run from a subdirectory: `Disk:   1g '/tmp'`. Scratch goes to `/tmp`, not to the current or input directory. |
| t64b | The same with `TMPDIR` set to a directory of its own: `Disk:   1g '<that directory>'`. |

## Round 7: capability matrix

NH3 (planar transition state of the inversion, with the DFT Hessian of t24 appended as the starting Hessian) and
water, `L1` basis. `tddft` inputs use `state=1,3`.

| Test | Result |
|---|---|
| t65a | `task=hessian`, `tddft`: numerical (`NUMERICAL COMPUTATION OF SECOND DERIVATIVES`), Hessian of excited state 1 of water: 891.65i, 773.75i, 3794.87 cm⁻¹. 20 s. |
| t65b | `task=hessian`, `qm_n3`: numerical; 1559.33, 3878.69, 4041.40 cm⁻¹. |
| t66a–e | `saddle=1` with `ridft`, `rimp2`, `ccsd`, `tddft`, `qm_n3`: all read the appended Hessian (`Lowest eigenvalues: -0.02919  0.18683`) and converge in one step to a planar structure (final E: ridft -56.4943555, rimp2 -56.3941298, ccsd -56.4079509, tddft (state 1) -56.2495461, qm_n3 -56.4184878). |
| t67a–e | `task=irc`, `points=3`, same five theories: all print the IRC header, points 0–3 on `IRC>` lines and the summary, three converged constrained optimizations, exit 0. |
| t68a,b,c,e | `task=scan` (the t37 scan, `points=3`) with `ridft`, `rimp2`, `ccsd`, `qm_n3`: three converged constrained optimizations and the `SCAN>` summary. |
| t68d | `task=scan` with `tddft`: the TDDFT iterations diverge (`iter=101…104: g= -nan`), then `0: write td.XK(100800:101760)?`, stderr `MPI_Abort`, exit 1. |
| t69a–f | `task=thermostat` with `$dynamic e=0.001 d=0.03 n=20,5 m=10 i=1` and `dft`, `ridft`, `rimp2`, `ccsd`, `tddft`, `qm_n3`: all run 26 points (`point -5` … `point 20`), exit 0. Header `THERMOSTAT`, `N = 9 K = 0 ne = 8`, `e = 0.001`, `dx = 0.03`, `L = 20,-5;10`; one line per point: `point N: s … a … b … w … r … d … E … g … U … P … z …`. Negative point numbers are the equilibration steps (second value of `n`). |

## Round 8: hard SCF cases

The Cu(II) complex is the chemport 112860 input (`05` §7.1) unchanged except `task=energy` (OLYP/L2, cation,
doublet, 22 atoms, `restrict=0`, `$grid acc=1e-12`). Cr₂ is a singlet at 1.679 Å with L1.

| Test | Result |
|---|---|
| t70a | Forum SCF settings (`procedure=BFGS iterations=999,999 convergence=1e-10`): **converged**, no divergence. Coarse grid (68 416 points) for iterations 0–19, fine grid (2 182 252 points) from iteration 20 (energy jump +0.0023 hartree), then smooth convergence; `converged!` after 48 iterations, E = -2061.0966862906, 7.8 min. The 2015 divergence does not reproduce in v25. |
| t70b | Default Newton–Raphson SCF (`restrict=0 convergence=1e-10`): converged after 10 iterations (fine grid from iteration 4), same E, 4.3 min. |
| t71 | Restart loop with `iterations=10`: converged in the first cycle (10 iterations, same E), so no restart happened. |
| t72 | `optimize+hessian` (`restrict=0 convergence=1e-10`, default procedure): every SCF converged; `OPTIMIZATION CONVERGED in 6 steps!` (E -2061.0967071 → -2061.0967122); the Hessian step's SCF converged and `ANALYTIC SECOND DERIVATIVES OF SCF ENERGY` started, then the run was killed by `run.sh`'s one-hour `timeout` (exit 124; output ends with `process 0 got signal 15`). No frequencies. |
| t73a | Cr₂ default: restricted, converged after 10 iterations, E = -2088.4673560475. |
| t73b | Cr₂ `restrict=0`, `$guess mix=1`: converged after 14 iterations to the **restricted** solution (identical alpha and beta orbital energies, same E). |
| t73c | The same with `procedure=bfgs`: 23 iterations, same restricted solution and E. |

With O₂ (t60) this makes two molecules where `$guess mix=1` gave no broken-symmetry solution in v25.

## Round 9

| Test | Result |
|---|---|
| t71b | Cu complex, restart loop with `iterations=3` per cycle: cycle 1 (`Initial Guess (2)`) ran on the coarse grid (68 416 points) and then the fine grid, ending `no convergence!` at E = -2061.0944031738. Cycles 2–4 printed `Initial Guess (-1)` and `vectors from 'cu.vec'`, **started directly on the fine grid** (no coarse-grid phase), and each began at the previous cycle's last energy (cycle 2 at -2061.0944031685). Cycle 4 ended `converged!`, E = -2061.0966862873: about 12 iterations in all. The fine-grid size differed slightly between cycles (2 175 976–2 188 180 points). |
| t74a | O2 triplet, vectors saved to `o2t.vec`: converged, E = -150.2228124217 (as t48). |
| t74b | Singlet O2, `restrict=0`, `$guess read=1` with the **triplet** vectors: accepted (`vectors from 'o2t.vec'`, 8 alpha and 8 beta electrons). After one iteration the energy was -150.20756, 0.048 hartree **below** the closed-shell singlet (-150.1593089, t48b) and 0.015 above the triplet; then it crept down by about 4·10⁻⁸ per iteration with the gradient stuck near 2·10⁻⁶ (threshold 1·10⁻⁶), ending `no convergence!` after 32 iterations at E = -150.2075743278. The printed alpha and beta orbital energies are identical, which for O2 does not exclude a broken-symmetry solution: alpha in one π* orbital and beta in the other, degenerate one, give the same lists *(inferred)*. Spin populations were not printed. |
| t72 | `optimize+hessian` for the Cu complex on **8 processes** (`NP=8`), no time limit: `parallel on 8 processors`; `OPTIMIZATION CONVERGED in 6 steps!`; all 20 SCF runs converged (no `no convergence`); `ANALYTIC SECOND DERIVATIVES OF SCF ENERGY` took about 1230 s of wall time; frequency table with one small imaginary mode (6.11i cm⁻¹; next 27.88, 28.09 cm⁻¹), ZPVE = 0.181703 a.u.; total REAL time 31.8 min. On one core (round 8) the same job had not finished after 60 min. |

## Round 10

| Test | Result |
|---|---|
| t74c | Singlet O2 from the triplet vectors with `iterations=300` and `print=+charges`: `converged!`, E = -150.2075771716 (0.0482 hartree below t48b, 0.0152 above the triplet). Hirshfeld spins 0.0000 on both atoms. Alpha and beta orbital lists identical; HOMO (8) -0.224237, LUMO (9) -0.168405, i.e. normal order with a π* splitting of 0.056 hartree. |
| t48b (re-read) | The closed-shell singlet of round 3 has HOMO (8) -0.178433 and LUMO (9) **-0.219175**: the LUMO lies below the HOMO. The `mix=1` runs t60a/b ended at the same energy. (Round 10 read this as an excited configuration; round 11 shows it is not one, see below.) |

Whether t74c is a broken-symmetry solution (alpha in one π*, beta in the other) or the aufbau closed-shell singlet (pair in the lower π*) cannot be told from these numbers: in O2 both have zero atomic spin populations by symmetry, and both give identical alpha and beta orbital-energy lists *(inferred)*. Round 11 t74d (`restrict=1` from the same vectors) decides it.

## Round 11

| Test | Result |
|---|---|
| t74a–c | Same energies as round 10 (triplet -150.2228124217, t74c -150.2075771716), also in the earlier run `20261017-180746`. |
| t74d | Singlet O2 from the triplet vectors with **`restrict=1`**: `converged!` (`6 F, 28 F1` in the output), E = -150.1593098509, i.e. the closed-shell energy of t48b (difference 9·10⁻⁷ hartree, within the convergence threshold), **0.0483 hartree above t74c**. Same orbital energies as t48b: HOMO (8) -0.178434, LUMO (9) -0.219172 (LUMO below HOMO again). Hirshfeld spins 0. |
| t74e | Default singlet run with `$guess na(8)=9,8 nb(8)=9,8` (orbitals 8 and 9 swapped in the start): `converged!` (`4 F, 15 F1`) to E = -150.1593089237, exactly t48b, with the same HOMO -0.178432 and LUMO -0.219175. The output does not show whether the swap was applied. |

Conclusions:
- **t74c is a broken-symmetry solution** (alpha electron in one π* orbital, beta in the other), not the closed-shell singlet: forced restricted from the very same starting vectors, the SCF falls back to the t48b energy. Its identical alpha and beta lists (occupied π* -0.224, empty π* -0.168 in each spin) fit that picture: each spin has one π* component filled.
- **The restricted closed-shell singlet of O2 has no aufbau solution.** With the pair in one of two degenerate π* orbitals, the filled one is pushed up by its own Coulomb repulsion and ends above the empty one; filling the other component (t74e's swap) only gives the symmetry-equivalent state with the same energy *(inferred: standard behaviour of Kohn–Sham with integer occupations of a degenerate shell)*. So t48b is not an "excited configuration" that a different start could escape, and the round-10 reading was wrong. The swap test is not decisive for `na`/`nb` themselves: in O2 any swap of the two π* components gives an equivalent state.
- Spin-projected estimate from these numbers (Yamaguchi, assuming ⟨S²⟩ = 1 for the broken-symmetry state and 2 for the triplet): E(singlet) ≈ 2·E(BS) − E(T) = -150.1923, a singlet–triplet gap of 0.0305 hartree (0.83 eV); the experimental a¹Δg–X³Σg⁻ gap is 0.98 eV *(my calculation, not program output)*.

## Molden check

The project owner cut a `freq>` file (vibrations, from a v25 Hessian output with `print=+molden`) and a `mos>` file
(orbitals, from round 3 t45, `print=+vectors+molden`) with the `sed`/`grep` recipes of the Getting started chapter
and opened both in Molden: both files open correctly. Cite as `08 Molden check`.

## Cosmetic

Every output ends with a repeated timing summary in which some lines show `0.0%` followed by a huge garbage number.
This is a display bug in the timing table *(inferred)* and does not affect results.
