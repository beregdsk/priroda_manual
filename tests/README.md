# Verification inputs (first round)

Small inputs that each answer one open question in the manual. Everything uses water or ammonia with the `L1` basis
from `basis.in`, so each run takes seconds to minutes on one core. The questions come from `PLAN.md` §3a and the
`<!-- verify -->` marks in `docs/`.

## How to run

```bash
PRIRODA=/path/to/p BASIS=/abs/path/to/basis.in ./run.sh          # everything
PRIRODA=/path/to/p BASIS=/abs/path/to/basis.in ./run.sh t22 t24  # tests whose name starts with t22 or t24
```

Optional variables: `BASIS4=/abs/path/to/basis4.in` enables t35, `QMBASIS=/abs/path/to/qm.in` enables t39, and
`MPIEXEC=/path/to/mpiexec` enables t21b (an `mpirun` on `PATH` enables t21c). Tests without what they need are listed
as skipped in `status.txt`.

`run.sh` fills in the placeholders (`@BASIS@`, `@THEORY@`, …), runs each input serially into `runs/<date>/`, keeps
stderr in `<name>.err` when there is any, and writes each exit status to `runs/<date>/status.txt`. t25 and t26 take
the Hessian from t24, and t27b reads the vectors saved by t27a, so run those groups together (`./run.sh t24 t25 t26`,
`./run.sh t27`). Note the version and build date from the output banner; every answer holds for that version.

After a run, record the answer in the Result column, add it to a `research/` note, then update the keyword YAML
(`default`, `verified_against`, `status`) or the chapter text and remove the `<!-- verify -->` mark it resolves.

## Round 1 (run 2026-10-17 on version 25; outputs in git history, `git show ef39f62:tests/runs/20261017-124819/<file>`)

The findings are written up in `research/08_test_runs_v25.md` and folded into the YAML and chapters.


| ID | Input | Question | What to look at in the output | Where it is used | Result |
|---|---|---|---|---|---|
| t01 | `t01_energy.in` | Baseline: does the documented water example run? Is an `eng>` block printed for `task=energy`? | Banner and version; `converged!`; final energy; Hirshfeld charges and bond orders; any `eng>` lines | getting-started (water); PLAN 3a.7 || Runs; E = -76.3653913723. `eng>` block **is** printed (E, D). `molecule input: ''` appears in every run. |
| t02 | `t02_defaults.in` | Defaults when `task`, `theory` and `$system` are all omitted | Which task and theory ran; `Memory:` and `Disk:` lines; scratch directory; `scf options:`, `grid: accuracy` echo lines | `control.task`, `control.theory`, running.md (`$system` defaults, scratch location); PLAN 3a.2, 3a.11 || task=gradient, theory=dft, PBE; `Memory: 256m + 512m`, no `Disk:` line; `iter=32,16`, grid `1e-8,1e-5`. |
| t03 | `t03_relative_basis.in` | Does a relative `basis=basis.in` resolve when the file is in the working directory? | Normal run, or a basis-file error | `control.basis`; common-problems (basis not found); PLAN 3a.3 || Works (file in the current directory). |
| t04 | `t04_shared_line.in` | Can two groups share one line? | Does `scf options:` show `conv=1.0e-07`, and does the grid echo show `1e-9`? | input-syntax (groups); PLAN 3a.4 || Works: both values echoed. |
| t05 | `t05_disabled_group.in` | Are text outside groups and a disabled group (`integral dir=1 $end`, no `$`) with its stray `$end` ignored? | Normal run with no complaint | input-syntax (text outside groups); PLAN 3a.4 || Both ignored; result identical to t01. |
| t06 | `t06_unknown_keyword.in` | What happens with an unknown keyword? | Expected form: `*** error in '$scf' : unknown name ...` | input-syntax (keywords); PLAN 3a.5 || Confirmed: `*** error in '$scf' : unknown name nosuchkeyword`, exit 1. |
| t07a | `t07a_conv_iter.in` | Do `convergence` and `iterations` together in `$scf` trigger `unknown name erations`, or get ignored? | Error message, or the values in `scf options:` | `scf.convergence`; common-problems (`$scf` settings ignored); PLAN 3a.5 || Error `unknown name terations`, exit 1. |
| t07b | `t07b_conv_iter_bfgs.in` | Same, with `procedure=bfgs` between them | `scf options:` line | as t07a || Works: `conv = 1.0e-07`, `iter=250,16`; BFGS table. |
| t08 | `t08_hybrid_with_dft.in` | `functional=PBE1` with `theory=dft`: is exact exchange silently dropped, or does the run abort? | Error message, or the functional/exchange lines and the energy (compare with a `theory=ridft` run if needed) | about.md warning; `control.theory`; PLAN 3a.6 || Aborts after the basis echo, **no message**, exit 1. |
| t09 | `t09_real_atomic_number.in` | Atomic numbers written as `8.0`: is the error `molecule input: ''` and `illegal charge/multiplicity`? | The error lines | common-problems (`molecule input: ''`) || **No error**: misread as 4 atoms (3 with Z=0), formula `__3O`, E = -74.77, exit 0. |
| t10 | `t10_multiplicity.in` | Is `mult` the multiplicity 2S+1 (OH radical, `mult=2`)? | Runs unrestricted with one unpaired electron | `molecule.mult`; PLAN 3a.12 || Yes (5α/4β). SCF did not converge in 32 iterations, but E printed and exit 0. |
| t11 | `t11_optimize.in` | The documented NH3 optimization | `OPTIMIZATION CONVERGED`; `MOL>` lines; that the `sed` recipe in getting-started extracts a usable geometry | getting-started (steps 1-3) || Converged in 6 steps; `mol>` every step, final `MOL>`; sed recipe works. |
| t12 | `t12_optimize_unconverged.in` | Is the last geometry printed when an optimization stops at `steps`? | `MOL>` or `mol>` lines at the end; the message printed at the step limit | getting-started; PLAN 3a.10 || No message at the limit; last geometry only as `mol>`. Defaults tol 1e-4/1e-2, trust 0.125/0.015625. |
| t13 | `t13_hessian.in` | Frequency table format, imaginary frequencies, ZPVE line, default temperature, rotational symmetry number | `Normal Mode` table; `ZPVE`; the `T =` line (298.000 or 298.150); whether a symmetry number is detected without `sigma=`; `freq>` lines | getting-started (steps 4-7); `thermo.temperature`, `thermo.sigma`; PLAN 3a.8, 3a.9 || Table `Harmonic Frequencies …` with `|` columns; ZPVE line; T = 298.150 K; σ **not** detected (σ=1 used). No imaginary modes to check. |
| t14 | `t14_optimize_hessian.in` | Does `task=optimize+hessian` work in this version? | Optimization followed by frequencies in one output | getting-started (one-run alternative) || Works. Default `steps` = 128. |
| t15 | `t15_symmetry.in` | What do `$molecule sym=1,0.01` and `$optimize sym=1` do? | `symmetry:` line; compare the steps and timing with t11 | `molecule.sym`, `optimize.sym`; about.md || C3v detected, geometry symmetrized, Cartesian optimizer, symmetric `MOL>`. Options not separated (see t30). |
| t16a | `t16a_mp2_default_core.in` | RI-MP2 runs; default frozen core | Number of core electrons or frozen orbitals reported | `atoms.core` || Runs; O 1s frozen (`core = 1`). |
| t16b | `t16b_mp2_atoms_core.in` | Is the `$atoms core` index `10·Z` (here `core(80)` for O)? | Core count differs from t16a (0 instead of 1s), or an error | `atoms.core`; PLAN 3a.12 || `core(80)` removed the O core: 10·Z layout confirmed. |
| t17 | `t17_theory_template.in` | Which undocumented `theory=` values run at all? `run.sh` makes one input per value: `hf rihf cis mp2 mp3 mp4dq mp4sdq mp4sdtq ccs ccd ccsd ccsd4t` | Normal end and an energy, or an error | `control.theory`; PLAN 3a.13 || All 12 run (exit 0). `ccs` = HF energy; `cis` prints 6 states. |
| t18 | `t18_task_check.in` | Does undocumented `task=check` process the geometry only? | Output stops after the geometry | `control.task`; PLAN 3a.13 || Stops after setup, no SCF. |
| t19 | (t01, output `T19_Capital.out`) | Does a capital letter in the output file name cause `output file '...'?` | That message | running.md; common-problems (file names) || No complaint. |
| t20 | (t01, no output file) | Does the output go to standard output when no output file is given? | `t20_stdout.stdout` | running.md || Yes. |
| t21 | (t01 on 2 processes) | Which parallel launch works: `p -np 2 in out` (t21a) or `./mpiexec -np 2 ./p in out` (t21b, if `mpiexec` sits next to `p`)? | Both outputs; same energy as t01 | running.md (parallel runs); PLAN 3a.1 || t21a `p -np 2` failed, no output, exit 1; stderr not captured. t21b not run. |

## Round 2 (run 2026-10-17 on version 25; outputs in git history, `git show ef39f62:tests/runs/20261017-124819/<file>`)

Small inputs again (water, ammonia, OH), except t32b, t33 and t36, which may take a few minutes.

| ID | Input | Question | What to look at in the output | Where it is used | Result |
|---|---|---|---|---|---|
| t21 | (t01 on 2 processes) | Rerun of the parallel launch, now with stderr kept. Which form works: `p -np 2` (t21a), the bundled `mpiexec` (t21b), or a system `mpirun` (t21c)? | `t21*.stdout` for error text; the process lines at the top of each output; same energy as t01 | running.md (parallel runs); PLAN 3a.1 || `p -np 2` rejected: `input file '-np'?.` then `MPI_Abort`. t21b/t21c not run (no launcher available). Retest in round 3. |
| t22a | `t22a_scf_conv_last.in` | Is `iterations=250 convergence=1e-7` (convergence last) read correctly? | `scf: conv = …; iter=…` line, or an error | `scf.convergence`; common-problems (`$scf` settings) || Works. |
| t22b | `t22b_scf_conv_own_line.in` | Does a line break end the value list (`convergence` and `iterations` on separate lines)? | as t22a | as t22a || Fails (`terations`): a line break does not help. |
| t22c | `t22c_scf_conv_two_values.in` | Does `convergence=1e-7,1e-3 iterations=250` give the forum error `unknown name erations`? | Error text | as t22a || Works. Rule: give both values or put `convergence` last. |
| t23 | `t23_ampersand_group.in` | Is a group opened with `&` (`&dft func=BLYP $end`) read? | `Approximation to E(xc)` in the summary box: BLYP or PBE | input-syntax (text outside groups) || Silently ignored (PBE used). |
| t24 | `t24_hessian_planar_nh3.in` | Planar NH3 is the inversion transition state. How is the imaginary frequency printed? | Frequency table; the first mode | getting-started (step 5); limor1 scripts expect an `i` suffix || One imaginary mode, printed `845.22i`. |
| t25 | `t25_saddle_from_hessian.in` | TS optimization with `saddle=1` and the t24 Hessian appended as `$Energy`. Is the Hessian read? | A message about reading the Hessian; steps; `OPTIMIZATION CONVERGED`; planar final geometry | `optimize.saddle`, `Energy.H`; input-syntax (`$Energy`) || Hessian read (`Lowest eigenvalues: -0.02919 …`), converged, stays planar. |
| t26 | `t26_irc_from_hessian.in` | IRC from the planar TS with the t24 Hessian, `points=10` | Path points, energies, the final message; one or both directions | `control.task` (irc), `optimize.points`, `optimize.back` || Works; `IRC>` lines; one direction; 7 points, ends with `Vicinity of a Stationary Point(?) --- STOP.` at the minimum. |
| t27a/b | `t27a_save_vectors.in`, `t27b_read_vectors.in` | Does `save=` write vectors, and does `$guess read=1` read them? | t27b: initial guess line and fewer SCF iterations than t27a | `control.save`, `guess.read`; common-problems (SCF restart) || Works: `Initial Guess (-1)`, `vectors from 't27.vec'`, 1 iteration. |
| t28a | `t28a_oh_more_iterations.in` | Does the OH radical of t10 converge with `iterations=100`? | `converged!` and the iteration count | common-problems (SCF) || Converges after 34 iterations. |
| t28b | `t28b_oh_bfgs.in` | Same with `procedure=bfgs` | as t28a | `scf.procedure` || Converges after 29 iterations (E 3·10⁻⁶ higher). |
| t29 | `t29_mol_block_charge.in` | Does the final `MOL>` block repeat `charge=-1` for OH⁻? | The `MOL>` lines | getting-started (step 2) || Yes: `MOL> charge=-1` (no `mult=` line for the default 1). |
| t30a | `t30a_molecule_sym_only.in` | What does `$molecule sym=1,0.01` alone do? | `symmetry:` lines; `Coordinates:` in the optimizer echo | `molecule.sym` || Detects C3v and symmetrizes the input; optimizer internal, symmetry not kept. |
| t30b | `t30b_optimize_sym_only.in` | What does `$optimize sym=1` alone do? | as t30a | `optimize.sym` || Cartesian optimizer, `symmetry: C1`: no effect alone. Both options are needed. |
| t31a | `t31a_ridft_default_functional.in` | Is PBE1 the default functional for `theory=ridft`? | `Approximation to E(xc)` | `dft.functional` || Yes, PBE1. |
| t31b | `t31b_ridft_pbe1.in` | Hybrid energy with `ridft` + `PBE1` (the correct way) | Normal end, energy | about.md hybrid warning || Works, same energy as t31a. |
| t32a | `t32a_hessian_ridft.in` | Does `task=hessian` work with `ridft` (analytic or numerical)? | Hessian heading; frequencies | about.md capability matrix (`?` cells) || Works, numerical. |
| t32b | `t32b_hessian_rimp2.in` | Same with `rimp2` | as t32a; run time | capability matrix || Works, numerical. |
| t32c | `t32c_optimize_hf.in` | Do gradients work with `theory=hf`? | `OPTIMIZATION CONVERGED` | `control.theory` notes || Yes, converged in 4 steps. |
| t33 | `t33_tddft.in` | GGA TDDFT with `state=1,5` | Excited-state table: energies, oscillator strengths | `control.state`; about.md (TDDFT) || Works; `Electronic Spectrum:` table with oscillator strengths; `E  =` is state 1. |
| t34 | `t34_nmr.in` | NMR shieldings with `theory=dft` | Shielding table format | `control.task` (nmr), `$nmr` || Works; without `standard`, shift = −shielding. |
| t35 | `t35_four_relativistic.in` | Scalar-relativistic `four=1` with `basis4.in` (needs `BASIS4`) | `Hamiltonian: scalar-relativistic`; nucleus model; energy | `control.four`, `control.nucleus` || Works: `Finite nucleus model (1)`, `Hamiltonian: scalar-relativistic`. |
| t36 | `t36_task_dipole.in` | `task=dipole` (numerical polarizabilities, for Raman) | What is printed; run time | `control.task` (dipole) || Works: 19 SCF runs in fields, result as a `num>` block. |
| t37 | `t37_scan.in` | Relaxed scan, adapted from the limor1 `NH3_scan-fix` example | One optimization per point; the per-point output marker; the dihedral sign | `control.task` (scan), `optimize.fix`, `optimize.value` || Works; 4 points incl. both ends; `SCAN>` summary. |
| t38a | `t38a_dft_n4_lpbevv.in` | Does `theory=DFT_n4` with `functional=LPBEVV` (2025 official inputs) run? | Method and functional in the summary box; energy | `control.theory`, `dft.functional` || Runs. |
| t38b | `t38b_ridft_lpbevvv.in` | Does `functional=LPBEVVV` with `ridft` run? | as t38a | `dft.functional` || Runs. |
| t39 | `t39_qm_n3.in` | Semiempirical QM model with `qm.in` (needs `QMBASIS`) | Energy; run time | `control.theory` (qm_n3) || Runs; short output format of its own, no `E  =` line. |
| t40 | `t40_coordinated_spelling.in` | Is `$optimize coordinated=` (the `input.txt` spelling) accepted? Any unique prefix of `coordinates` would be. | Error `unknown name coordinated`, or a normal run | `optimize.coordinates` || No error, but inconclusive (see t40b/t40c). |

## Round 3 (run 2026-10-17 on version 25; outputs in git history, `git show ef39f62:tests/runs/20261017-124819/<file>`)

| ID | Input | Question | What to look at in the output | Where it is used | Result |
|---|---|---|---|---|---|
| t21 | (t01 on 2 processes) | Parallel launch through an MPI launcher. Download `mpiexec` from the official site next to `p` (or set `MPIEXEC=`), or have `mpirun` on `PATH`. | `t21b_*.stdout`, `t21c_*.stdout`; the process lines at the top of the output; same energy as t01 | running.md (parallel runs) || Not run: no `mpiexec` or `mpirun` available. Moved to round 4. |
| t40b | `t40b_coordinated_in_optimize.in` | Is `coordinated=` (the `input.txt` spelling) accepted in an optimization? | Error `unknown name coordinated`, or a normal run | `optimize.coordinates` || Rejected: `unknown name coordinated`. The keyword is `coordinates`. |
| t40c | `t40c_unknown_in_unused_group.in` | Is a group the task does not use (`$optimize` in an energy run) checked for unknown keywords? | Error, or a normal run (then t40 tells nothing) | input-syntax (keywords) || No error: groups the task does not read are not checked. |
| t41 | `t41_two_energy_groups.in` | Two `$Energy` groups (first from t13, pyramidal NH3; then from t24, planar). Which one is read? | `Lowest eigenvalues:` line: negative (t24 group) or positive (t13 group) | input-syntax (appending `$Energy`) || Second group (planar, t24) used, but it also matched the geometry. See t41b. |
| t42 | `t42_irc_back.in` | IRC with `back=1`: does it go the other way? | `n = 1, back = 1`; final geometry mirror image of t26 | `optimize.back` || Yes: other direction, negative distances, mirror-image end point. |
| t43 | `t43_minimize_from_saddle.in` | A plain optimization from planar NH3 with its Hessian appended: does it leave the saddle point? | Final `MOL>` geometry pyramidal, energy about -56.4989 | getting-started (step 6) || Yes: pyramidal minimum after 19 steps, E = -56.4988673. |
| t44 | `t44_thermo_sigma_temps.in` | `$thermo sigma=3 temperature=200,298.15,400` | Three thermochemistry tables; S lower by R ln 3 = 2.18 cal/(mol·K) than t13 at 298.15 K | `thermo.sigma`, `thermo.temperature` || Three tables; S lower by 2.18 cal/(mol·K) (R ln 3) with `sigma=3`. |
| t45 | `t45_molden_orbitals.in` | `print=+vectors+molden`: are orbitals written as `mos>` lines? | `mos>` lines; whether Molden opens them | getting-started (viewing in Molden) || 767 `mos>` lines in Molden format; the recipe works. Not opened in Molden. |
| t46 | `t46_hybrid_with_tddft.in` | Hybrid functional with `theory=tddft`: abort like `dft` (t08) or run? | Error or excited states | `control.theory` (hybrid trap) || **Runs without the exact exchange**: Ex -6.61 instead of -8.95, energies wrong by about 2.2 hartree, no warning. |
| t47 | `t47_unit_bohr.in` | `$molecule unit=b`: coordinates in bohr (t01 water converted) | Same energy as t01 | `molecule.unit` || Same geometry and energy as t01. |
| t48 | `t48_o2_triplet.in` | O2 triplet with default settings (`restrict` default for an even electron count) | Number of alpha/beta electrons; `converged!`; energy | `scf.restrict`, `molecule.mult` || Unrestricted (9α/7β), converged, E = -150.22281. |
| t48b | `t48b_o2_singlet.in` | O2 singlet for comparison | Energy above the triplet | `molecule.mult` || Closed shell, 0.0635 hartree above the triplet. |
| t49 | `t49_basis4_without_four.in` | `basis4.in` without `four=1` (needs `BASIS4`): does it stop at the `Basis set input:` line, as reported? | Where the output ends; error text | common-problems (basis file); `control.four` || Stops after the basis line with `1?`; exit 1. |


## Round 4 (run 2026-10-17 on version 25; outputs in git history, `git show f04d4f5:tests/runs/20261017-130725/<file>`)

Run with:

```bash
cd tests
PRIRODA=/path/to/p BASIS=/abs/path/to/basis.in ./run.sh t13 t24 t36 t41b t50 t53 t55 t56 t57
```

t13, t24 and t36 are rerun because t41b, t55c and t56 take their Hessians or `num>` lines from those outputs in the
same run. For the parallel test, download `mpiexec` from the official site and put it next to `p` (or give its
path), then:

```bash
PRIRODA=/path/to/p BASIS=/abs/path/to/basis.in MPIEXEC=/path/to/mpiexec ./run.sh t21
```

| ID | Input | Question | What to look at in the output | Where it is used | Result |
|---|---|---|---|---|---|
| t21 | (t01 on 2 processes) | Does `mpiexec -np 2 p in out` (t21b) or a system `mpirun` (t21c) start a parallel run? | `t21b_*.stdout`, `t21c_*.stdout`; the process lines at the top of the output; same energy as t01 | running.md (parallel runs) || `p -np` rejected again; **`mpiexec -np 2 p in out` works** (2 processes, same energy). |
| t41b | `t41b_two_energy_groups_reversed.in` | Same as t41 with the groups swapped (planar first, pyramidal last). Does the last group win? | `Lowest eigenvalues:` positive (last group used) or -0.02919 (matching group used) | input-syntax (several `$Energy` groups) || Last group used (positive eigenvalues). |
| t50 | `t50_unknown_task.in` | `task=nosuchtask`: error, or setup and a quiet stop like `task=check`? The program has no `check` task (`research/09`). | Where the output ends; exit status | `control.task` (`check`) || No error: setup, then a quiet stop, like `check`. |
| t50b | `t50b_unknown_theory.in` | `theory=nosuchtheory`: error or a silent fallback? | Error text, or the `Theoretical Method` line | `control.theory` || **No error: runs Hartree–Fock** (E = HF energy). |
| t53 | `t53_numeric_hessian_dft.in` | `$control derivative=numeric` (a keyword found only in the program) with `theory=dft`: numerical Hessian instead of analytic? | `NUMERICAL COMPUTATION OF SECOND DERIVATIVES`; frequencies as in an analytic run | `research/09`; `$d2edr2` || Yes, numerical; frequencies equal the analytic ones within 0.2 cm⁻¹. |
| t55a/b/c | `t55a…`, `t55b…`, `t55c…` | Numerical Hessian split over two runs (`$d2edr2 displace=1 steps=0,4` and `5,9`), then combined with `steps=-1` and the `num>` lines of both | t55a/b: `num>` lines; t55c: frequency table, compared with a one-run `ridft` Hessian (round 2 t32a) | `d2edr2.steps`; input-syntax (`num>` lines) || Works: 1643.00 / 3910.51 / 4018.62 cm⁻¹ (one-run: 1642.79 / 3910.72 / 4018.26). The `input.txt` sed recipe leaves file names; use `grep -h`. |
| t56 | `t56_raman_from_dipole.in` | Raman intensities: a Hessian run with the `num>` lines of `task=dipole` (t36) appended | Non-zero `Raman A.` and `Raman D.` columns | input-syntax (`num>` lines); getting-started (Raman) || Works: Raman activities and depolarization ratios filled in. |
| t57a | `t57a_nmr_ridft.in` | NMR with `theory=ridft` (sources say NMR works only with `dft`) | Shielding table or an error | about.md capability matrix (note 5) || No shieldings: only the SCF energy, no message. |
| t57b | `t57b_nmr_standard.in` | `$nmr standard(1)=31.0 standard(8)=300.0`: shift = standard − shielding? | `shift=` values (H about -1.78, O about -36.88) | `nmr.standard` || Yes: shift = standard − shielding (H −1.7773, O −36.8797). |

## Round 5 (run 2026-10-17 on version 25; outputs in git history, `git show 192f430:tests/runs/20261017-131420/<file>`)

Run with (the `mpiexec` from the official site is needed for t59 and t63):

```bash
cd tests
PRIRODA=/path/to/p BASIS=/abs/path/to/basis.in MPIEXEC=/path/to/mpiexec ./run.sh t58 t59 t60 t61 t62 t63
```

| ID | Input | Question | What to look at in the output | Where it is used | Result |
|---|---|---|---|---|---|
| t58a | `t58a_input_syntax_example.in` | The first example of the Input syntax chapter, exactly as printed (`$system mem=512 disk=-512 path=/tmp`) | `Memory:` line with the RAM disk; `OPTIMIZATION CONVERGED` | input-syntax (first example) || Works as printed (RAM disk echoed as `512m + 512m`). |
| t58b | `t58b_molecule_one_line_header.in` | `$molecule charge=0 mult=1 cartesian` on one line | Same energy as t01 | input-syntax (`$molecule`) || Works. |
| t59 | `t59_relative_basis_parallel.in` | Relative `basis=basis.in` in a 2-process run (basis file in the run directory) | Normal run, or `MPI_Abort` as in the old forum report | common-problems (basis file not found) || Works on 2 processes. |
| t60a | `t60a_broken_symmetry_dft.in` | Singlet O2 with `restrict=0` and `$guess mix=1`, pure DFT: does the solution break spin symmetry? | Spin populations; energy compared with t48b (closed-shell singlet) and t48 (triplet) | `guess.mix`; common-problems (open-shell singlets) || No symmetry breaking: identical α/β, closed-shell energy. |
| t60b | `t60b_broken_symmetry_ridft.in` | The same with `ridft`/PBE1 | as t60a | as t60a || No symmetry breaking either. |
| t61 | `t61_too_little_memory.in` | `$system mem=2`: what message does too little memory give? | Error text (`malloc(...) failed`?) | running.md; common-problems (memory) || `need 12544 + 7905408 = 7917952 bytes.`, exit 1. |
| t62 | `t62_too_little_disk.in` | Conventional MP2 with a 1 MB RAM disk: what message does too little scratch give? | Error text (`out of disk space`?) | common-problems (disk) || `0: out of disk space (grid_W), 8213824`, exit 1. |
| t63 | `t63_parallel_ridft_hessian.in` | Numerical `ridft` Hessian on 2 processes | Frequencies as in the serial run (round 2 t32a: 1642.79, 3910.72, 4018.26); run time | running.md (parallel performance) || Same frequencies as serial; 4.85 s vs 7.17 s. |

## Round 6 (run 2026-10-17 on version 25; outputs in git history, `git show 7d6391c:tests/runs/20261017-131753/<file>`)

```bash
cd tests
PRIRODA=/path/to/p BASIS=/abs/path/to/basis.in ./run.sh t64
```

| ID | Input | Question | What to look at in the output | Where it is used | Result |
|---|---|---|---|---|---|
| t64a | `t64_scratch_location.in` with `TMPDIR` unset | Where do scratch files go when neither `path=` nor `TMPDIR` is set: current directory or `/tmp`? | The `Disk:` line in `t64a/t64_scratch_location.out` | running.md (where scratch files go) || `/tmp`. |
| t64b | the same with `TMPDIR` set to `t64b/tmpdir` | Is `TMPDIR` used when `path=` is not given? | The `Disk:` line in `t64b/t64_scratch_location.out` | `system.path` || Yes, `TMPDIR` is used. |

## Round 7: capability matrix (run 2026-10-17 on version 25; outputs in `runs/20261017-133258/`)

Fills the `?` cells of the capability matrix in about.md: which `task=` values work with which `theory=`. Each test
asks only "does this task run with this theory, and does it finish normally?". All use water or NH3 with `L1`.
t66 and t67 start from the planar-NH3 transition state with the DFT Hessian of t24 appended (only as a starting
Hessian), so t24 must be in the same run. The `tddft` inputs use `state=1,3` (gradient of state 1). The `ccsd` column
of the matrix also stands for `ccsd4t`; only `ccsd` is tested. The `*_qm_n3` tests need `QMBASIS`. CCSD runs may take
several minutes.

```bash
cd tests
PRIRODA=/path/to/p BASIS=/abs/path/to/basis.in QMBASIS=/abs/path/to/qm.in ./run.sh t24 t65 t66 t67 t68 t69
```

| ID | Input | Question | What to look at in the output | Where it is used | Result |
|---|---|---|---|---|---|
| t65a | `t65a_hessian_tddft.in` | `task=hessian` with `tddft`: excited-state frequencies, ground-state ones, or an error? | Hessian heading (analytic or numerical); frequency table; exit status | about.md matrix (`hessian` × `tddft`) || |
| t65b | `t65b_hessian_qm_n3.in` | `task=hessian` with `qm_n3` | Frequency table; exit status | matrix (`hessian` × `qm_n3`) || |
| t66a–e | `t66{a..e}_saddle_{ridft,rimp2,ccsd,tddft,qm_n3}.in` | TS search (`saddle=1`) with each theory | `Lowest eigenvalues:` (Hessian read); `OPTIMIZATION CONVERGED`; final geometry planar | matrix (TS row) || |
| t67a–e | `t67{a..e}_irc_{…}.in` | `task=irc` (`points=3`) with each theory | `Intrinsic Reaction Coordinate` header; `IRC>` points with falling energy | matrix (`irc` row) || |
| t68f | `t68f_scan_tddft_all_bonds_fixed.in` | t68d with all three N–H bonds fixed: does a TDDFT scan work when the excited state cannot dissociate? | `SCAN>` summary | matrix (`scan` row, note 9) | Yes: 3 points, run in the cloud session (`runs/20261017-183348/`). t68d had failed because the state broke an N–H bond. |
| t68a–e | `t68{a..e}_scan_{…}.in` | `task=scan` (the t37 scan, `points=3`) with each theory | One converged constrained optimization per point; `SCAN>` summary | matrix (`scan` row) || |
| t69a–f | `t69{a..f}_md_{dft,ridft,rimp2,ccsd,tddft,qm_n3}.in` | `task=thermostat` (MD, `$dynamic n=20,5`) with each theory. t69f (`qm_n3`) is the control: the official examples show MD with the QM model, so if t69f fails, the `$dynamic` settings are at fault, not the theory | Trajectory steps with energies; exit status; run time | matrix (MD row); `$dynamic` meanings || |

The Molden recipes were checked by hand: `freq>` and `mos>` files cut with the Getting started recipes open correctly
in Molden.

## Round 8: hard SCF cases (run 2026-10-17 on version 25; outputs in `runs/20261017-135441/`)

Two molecules whose SCF is known to be difficult:

- **A Cu(II) complex** (Cu with two methylamine ligands and an acetate, cation, doublet, 22 atoms), taken unchanged
  from chemport thread 112860 (`research/05` §7.1). With OLYP/L2, `restrict=0`, `procedure=BFGS` and a very fine grid
  (`acc=1e-12`), the forum user's SCF converged on the coarse grid and then diverged after the switch to the fine
  grid (energy up to +29 hartree). Two experienced users proposed fixes that the manual describes but nobody has
  confirmed. Each Cu run may take several minutes or more.
- **Cr₂** at its equilibrium distance (1.679 Å), singlet: a textbook case of strong static correlation, where the
  restricted and the broken-symmetry solutions differ a lot and the SCF often oscillates. Only two atoms, so fast.

```bash
cd tests
PRIRODA=/path/to/p BASIS=/abs/path/to/basis.in ./run.sh t70 t71 t73
# optional, long (optimization + Hessian of the Cu complex, possibly hours):
PRIRODA=/path/to/p BASIS=/abs/path/to/basis.in LONG=1 ./run.sh t72
```

| ID | Input | Question | What to look at in the output | Where it is used | Result |
|---|---|---|---|---|---|
| t70a | `t70a_cu_forum_scf.in` | Does the forum failure reproduce in v25? Same SCF settings (BFGS, `iterations=999,999`, `acc=1e-12`), but `task=energy` instead of `hessian`, since the failure is in the SCF | The SCF table after the second `grid:` line: does the energy oscillate and diverge, or converge? | common-problems (divergence after the switch to the fine grid) || **Converged** (48 iterations, 7.8 min): the forum divergence does not reproduce in v25. |
| t70b | `t70b_cu_default_nr.in` | First proposed fix, SCF part: drop `procedure=BFGS` and `iterations` (default Newton–Raphson, 32 iterations) | `converged!` or `no convergence!`; final energy compared with t70a | same || Converged in 10 iterations, 4.3 min, same energy. |
| t71 | `t71_cu_restart_loop.in` (run as cycles) | The restart loop: `iterations=10` and `save=cu.vec`, then rerun with `$guess read=1` until converged (at most 8 cycles; `run.sh` does the cycling) | `status.txt`: in which cycle it converged; each cycle's last SCF energy; `Initial Guess (-1)` from cycle 2 on | common-problems (restart from saved vectors) || Converged in the first cycle, so no restart was needed. See t71b. |
| t72 | `t72_cu_optimize_hessian.in` (only with `LONG=1`) | Second proposed fix in full: `task=optimize+hessian` with `restrict=0 convergence=1e-10`, each step starting from the previous wavefunction | `OPTIMIZATION CONVERGED`; the Hessian SCF converges; frequency table | common-problems (fine-grid divergence fix) || Optimization converged in 6 steps, all SCFs converged; killed by the 1-hour time limit during the analytic Hessian (`process 0 got signal 15`). Rerun without a limit in round 9. |
| t73a | `t73a_cr2_default.in` | Cr₂ singlet with default settings | `converged!` or `no convergence!`; energy; restricted (no beta orbitals printed) | common-problems (SCF; transition metals) || Converged (10 iterations), restricted. |
| t73b | `t73b_cr2_broken_symmetry.in` | Cr₂ with `restrict=0` and `$guess mix=1`: does it find a broken-symmetry solution? | Alpha and beta orbital energies differ; energy below t73a; spin populations | `guess.mix`; common-problems (broken symmetry) || Converged back to the restricted solution: no symmetry breaking. |
| t73c | `t73c_cr2_bfgs.in` | The same with `procedure=bfgs` and `iterations=250` | Convergence and energy compared with t73b | `scf.procedure` || Same restricted solution (23 iterations). |

## Round 9 (run 2026-10-17 on version 25; outputs in `runs/20261017-152445/` and, for t72, `runs/20261017-153851/`)

```bash
cd tests
PRIRODA=/path/to/p BASIS=/abs/path/to/basis.in ./run.sh t71b t74
# the long run again, now without the 1-hour limit; let it finish before pushing (possibly hours):
PRIRODA=/path/to/p BASIS=/abs/path/to/basis.in LONG=1 TIMEOUT=0 ./run.sh t72
```

| ID | Input | Question | What to look at in the output | Where it is used | Result |
|---|---|---|---|---|---|
| t71b | `t71b_cu_restart_loop_short.in` (run as cycles) | The restart loop with only 3 iterations per cycle, so that restarts really happen. Does each cycle continue from the saved vectors, and does the loop converge? Does a restarted run begin on the coarse grid again? | `status.txt` (cycle of convergence); in each cycle `Initial Guess (-1)`, the first SCF energy (close to the previous cycle's last?) and the `grid:` lines | common-problems (restart from saved vectors) || Converged in cycle 4 (about 12 iterations). Restarts continue from the previous energy and skip the coarse grid. |
| t74a | `t74a_o2_triplet_save.in` | O2 triplet, vectors saved to `o2t.vec` | `converged!` | — || Converged (as t48). |
| t74b | `t74b_o2_singlet_from_triplet.in` | Singlet O2 (`restrict=0`) started from the triplet vectors: a broken-symmetry solution, which `mix=1` never gave? | `vectors from 'o2t.vec'` (accepted despite the different multiplicity?); alpha and beta orbital energies differ; E below the closed-shell singlet (-150.1593089, round 3 t48b) | common-problems (open-shell singlets) || Triplet vectors accepted; a singlet 0.048 hartree below the closed-shell one, but **not converged** after 32 iterations (gradient 1.7·10⁻⁶, slowly falling). See t74c. |
| t72 | (as in round 8) | `optimize+hessian` for the Cu complex, run to the end | `OPTIMIZATION CONVERGED`; Hessian SCF converged; frequency table | common-problems (fine-grid fix) || Done on 8 processes in 32 min: optimization (6 steps), all SCFs converged, analytic Hessian; one tiny imaginary mode (6.11i). |

## Round 10 (run 2026-10-17 on version 25; outputs in `runs/20261017-174656/`)

```bash
cd tests
PRIRODA=/path/to/p BASIS=/abs/path/to/basis.in ./run.sh t74
```

(`t74` runs t74a, which saves the triplet vectors, then t74b and t74c, which read them.)

| ID | Input | Question | What to look at in the output | Where it is used | Result |
|---|---|---|---|---|---|
| t74c | `t74c_o2_singlet_from_triplet_long.in` | The t74b singlet with `iterations=300` and `print=+charges`: does it converge, and is it a broken-symmetry solution? | `converged!`; final energy (below -150.2075743?); Hirshfeld spins on the two O atoms (about +1 and −1 for a broken-symmetry singlet, 0 for closed shell) | common-problems (open-shell singlets) || Converged, E = -150.2075772, normal HOMO/LUMO order. Spins 0 on both atoms, which for O2 does not decide broken symmetry vs closed shell. Round 3's closed-shell singlet (t48b) has its LUMO *below* its HOMO. See t74d. |

## Round 11

```bash
cd tests
PRIRODA=/path/to/p BASIS=/abs/path/to/basis.in ./run.sh t74
```

(`t74` runs t74a, which saves the triplet vectors, then t74b–t74d, which read them, and t74e. t74b and t74c are
rerun only because they share the prefix; they are quick.)

| ID | Input | Question | What to look at in the output | Where it is used | Result |
|---|---|---|---|---|---|
| t74d | `t74d_o2_singlet_restricted_from_triplet.in` | Singlet O2 from the triplet vectors, but **restricted** (`restrict=1`). Same energy as t74c (-150.2075772) → t74c is the closed-shell singlet; higher → t74c is broken-symmetry | `converged!`; E; HOMO/LUMO order | common-problems (open-shell singlets) | E = -150.1593099 = t48b, 0.048 above t74c: **t74c is broken-symmetry**. LUMO below HOMO again. |
| t74e | `t74e_o2_singlet_swapped_guess.in` | Default singlet run (like t48b) with orbitals 8 and 9 swapped in the starting guess (`na(8)=9,8 nb(8)=9,8`): does that avoid the LUMO-below-HOMO state of t48b? | E (t48b: -150.1593089; t74c: -150.2075772); HOMO below LUMO | common-problems (LUMO below the HOMO) | Same state and energy as t48b. For O2 the swap gives a symmetry-equivalent state: the closed-shell singlet has no solution with the LUMO above the HOMO. |

## Round 12

```bash
cd tests
PRIRODA=/path/to/p BASIS=/abs/path/to/basis.in ./run.sh t75
```

Water has no degenerate orbitals, and its HOMO (1b1) and LUMO (4a1) differ in symmetry, so a closed-shell state
with the pair moved from the HOMO to the LUMO should be a stable SCF solution that the program can get stuck in.
t75b makes that state on purpose; t75c and t75d start from its vectors (each from a fresh copy). All four runs take
seconds.

| ID | Input | Question | What to look at in the output | Where it is used | Result |
|---|---|---|---|---|---|
| t75a | `t75a_h2o_ground.in` | Ground-state reference | E; HOMO (5) and LUMO (6) energies | common-problems (LUMO below the HOMO) |  E = -76.3653914; HOMO -0.233, LUMO 0.059. |
| t75b | `t75b_h2o_excited_swap.in` | Start with orbitals 5 and 6 swapped (`na(5)=6,5 nb(5)=6,5`): does the SCF stay in the excited configuration, and does it then show the LUMO below the HOMO? Saves the vectors | `converged!`; E above t75a?; occupied 5 above virtual 6? | `guess.na`, `guess.nb`; common-problems |  Swap accepted (`12 F, 42 F1` instead of `5 F, 12 F1`) but the SCF returned to the ground state: E = t75a. The excited state did not hold. |
| t75c | `t75c_h2o_read_excited.in` | Read the t75b vectors with no reordering: does the run stay in the excited state? | `vectors from 'h2ox.vec'`; E = t75b or t75a | common-problems (restarting from wrong vectors) |  t75b had saved ground-state vectors, so this; converged at once, E = t75a. |
| t75d | `t75d_h2o_read_excited_swap_back.in` | Read the t75b vectors and swap 5 and 6 back: does that return to the ground state? Also shows whether `na`/`nb` act on vectors read from a file | E = t75a?; HOMO below LUMO | common-problems (the fix); `guess.na` with `read=1` |  Swap applied to the read vectors (`11 F, 35 F1`), back to the ground state, E = t75a. |

## Round 13 (run in the cloud session on `p4_d`; outputs in `runs/20261017-182407/`)

```bash
cd tests
PRIRODA=/path/to/p BASIS=/abs/path/to/basis.in ./run.sh t76 t77
```

t76 tries to reproduce the crash with `process 0 got signal 6` and `too few` at the end of the `INTERNAL COORDINATES`
table, which one forum thread reported for an optimization, and its suggested fix `cartesian=1`. The usual trigger for
"too few" internal coordinates is a molecule that is or becomes linear *(inferred)*. t77 tests the IRC step-size advice
on a hydrogen shift (HCN ⇄ HNC): t77a–c find the transition state and its Hessian, t77d–h run IRCs with three step sizes.
t77c–h take the geometry from t77b through the new `@MOL_FROM_tNN@` placeholder (the last `MOL`-prefixed `$molecule`
group of that output), so run t77 as a whole. All runs are small; t77f and t77g may take several minutes.

| ID | Input | Question | What to look at in the output | Where it is used | Result |
|---|---|---|---|---|---|
| t76a | `t76a_co2_bent_internal.in` | CO2 started 10° bent, default internal coordinates: does it crash (`signal 6`, `too few`) when it straightens? | End of output; last `INTERNAL COORDINATES` table; `OPTIMIZATION CONVERGED`? | common-problems (signal 6) |  Converged in 12 steps; internal coordinates went from 5 to 4 as CO2 straightened. No crash. |
| t76b | `t76b_co2_bent_cartesian.in` | The same with `cartesian=1` | Converges to linear CO2? | common-problems (signal 6); `optimize.cartesian` |  Converged in 6 steps; same energy. |
| t76c | `t76c_c2h2_bent_internal.in` | Acetylene started trans-bent, internal coordinates | As t76a | common-problems |  Converged in 24 steps (internal coordinates 9 then 7). No crash. |
| t76d | `t76d_c2h2_bent_cartesian.in` | The same with `cartesian=1` | As t76b | common-problems |  6 steps; same energy. |
| t76e | `t76e_c2h2_linear_internal.in` | Acetylene already linear (bond lengths off), internal coordinates | As t76a; how are linear angles handled? | common-problems |  2 steps; 7 internal coordinates. |
| t77a | `t77a_hcn_ts_guess_hessian.in` | Hessian at a guessed HCN ⇄ HNC transition state | One imaginary frequency? | (input for t77b) |  1121.2i cm⁻¹, one imaginary mode. |
| t77b | `t77b_hcn_saddle.in` | Saddle search (`saddle=1`) from the guess with the t77a Hessian | Converged; final geometry (H bridging C and N) | (input for t77c–h) |  Converged in 3 steps; E(TS) = -93.26204880. |
| t77c | `t77c_hcn_ts_hessian.in` | Hessian at the found TS | Exactly one imaginary frequency (H moving between C and N) | common-problems (IRC) |  One imaginary mode, 1090.2i cm⁻¹. |
| t77d | `t77d_hcn_irc_rdefault_back0.in` | IRC, default `radius` (0.1), `points=30`, one direction | Number of points; does it reach HCN or HNC; `Vicinity of a Stationary Point(?) --- STOP.` early (on the first steps)? | common-problems (IRC stops early); `optimize.radius` |  19 points to HCN; normal end (`Vicinity…` then `Energy Minimum Passed…`). |
| t77e | `t77e_hcn_irc_rdefault_back1.in` | The same, other direction (`back=1`) | As t77d; the other minimum | `optimize.back` |  21 points to HNC; normal end. |
| t77f | `t77f_hcn_irc_r003_back0.in` | `radius=0.03`, `points=100` | Does the smaller step avoid an early stop, if t77d/e had one? Same end point? | common-problems (IRC step size) |  60 points; ends closest to HCN (g = 0.0003). |
| t77g | `t77g_hcn_irc_r003_back1.in` | The same, `back=1` | As t77f | common-problems |  69 points to HNC. |
| t77h | `t77h_hcn_irc_r03_back0.in` | `radius=0.3` (larger step) | Early stop or overshoot? | common-problems |  7 points; stops farthest from the minimum (g = 0.010). No early stop with any step. |

## Slurm (run in the cloud session; outputs in `runs/slurm-*`)

For the "Batch systems" section of running.md. The scripts in `tests/slurm/` install a single-node Slurm on an
Ubuntu or Debian PC (the PC is both controller and compute node) and submit the manual's job script with small jobs.
They were run in the cloud session on Slurm 23.11 with Priroda 25. The manual's original script failed (s01), and
`manual.sbatch` now holds the corrected version that the manual shows.

```bash
cd tests/slurm
sudo ./setup_slurm.sh              # once: installs slurm-wlm and munge, writes /etc/slurm/slurm.conf; sinfo shows "idle"
PRIRODA=/path/to/p MPIEXEC=/path/to/mpiexec BASIS=/abs/path/to/basis.in ./run_slurm.sh     # about 10-15 minutes
sudo ./setup_slurm.sh remove       # afterwards, if you do not want to keep Slurm
```

`manual.sbatch` is the script from running.md, with only its three site-specific paths (`PRIRODA`, `MPIEXEC`, the
scratch base) taken from the environment; `manual_trap.sbatch` moves the scratch clean-up into a trap. Jobs use 2
processes (`NP=` to change) and `/tmp/priroda-slurm/<job id>` as the node-local scratch (`SCRATCH_BASE=` to change).
Outputs go to `runs/slurm-<date>/<test>/`; `status.txt` summarizes each job's final state and any scratch left behind.

| ID | Script | Question | What to look at | Where it is used | Result |
|---|---|---|---|---|---|
| s01 | `manual.sbatch`, water | Does the manual's script work: `$SLURM_NTASKS` reaches `mpiexec`, scratch in the job's `TMPDIR`, removed at the end? | `s01/mol.out`: process lines (2), `Disk:` echo, E = t01; status: scratch removed | running.md (SLURM script) |  As written: **failed** (`Environment is too large (max is 193)`; Slurm still said COMPLETED). With `env -i` and `exit $status`: works, 2 processes, E = t01, scratch removed. |
| s02 | `manual.sbatch`, Cu complex, `scancel` after 60 s | What does a cancelled run print, and is its scratch left behind? (The `rm` at the end of the script cannot run.) | Tail of `mol.out` (`signal 15`?); `slurm-<id>.out`; `scratch_left.txt` | running.md; common-problems (signal 15) |  `process 0 got signal 15`; Priroda deleted its scratch files, the empty job directory stayed. |
| s03 | `manual_trap.sbatch`, same | Does the trap remove the scratch after `scancel`? | status: scratch removed | running.md (suggested script) |  Trap removed the directory. |
| s04 | `manual.sbatch`, Cu complex, `--time=1` | What happens at the time limit? | Tail of `mol.out`; `DUE TO TIME LIMIT` in `slurm-<id>.out`; scratch left? | running.md |  `DUE TO TIME LIMIT`, same signal lines, scratch files deleted, empty directory left. |
| s05 | `manual.sbatch`, two water jobs with `--ntasks=1` | Do two Priroda jobs run side by side on one node, each with its own scratch? | `s05_queue.txt` (both `R`); both E = t01; both scratch removed | running.md (several independent jobs) |  Both ran at once and completed. |

PBS/Torque is not tested: it is hard to install on one PC. Its script in running.md differs only in the header lines
and in reading the number of cores from `$PBS_NODEFILE`.

## Windows (not run yet)

These need a Windows computer with the files from the `exe64/` folder of the official site: `p1.exe` and
`cygwin1.dll` in one folder, and `basis.in`. For w13 also `p_190306.exe` and, for the 2-process run, an MPI launcher
(`orterun.exe` or `mpirun.exe` with the Cygwin OpenMPI DLLs, as in running.md). Do not install Cygwin for these tests:
most of them check what happens with only the two files.

In PowerShell, in the `tests` folder:

```powershell
$env:PRIRODA = "C:\Priroda\p1.exe"
$env:BASIS   = "C:\Priroda\basis.in"
powershell -ExecutionPolicy Bypass -File .\run_windows.ps1            # all (a few minutes)
powershell -ExecutionPolicy Bypass -File .\run_windows.ps1 w02 w05    # selected tests
```

Optional: `$env:PRIRODA_MPI = "C:\Priroda\p_190306.exe"` and `$env:MPIRUN = "C:\Priroda\orterun.exe"`.
Outputs go to `runs\win-<date>\`; `env.txt` there lists the Windows version and the exe and DLL files next to the
program, which the results depend on. The script writes every input with Unix line endings, whatever git did on
checkout; only w06 gets Windows endings. The Linux water energy to compare with is t01, E = -76.3653913723.

| ID | Input | Question | What to look at in the output | Where it is used | Result |
|---|---|---|---|---|---|
| w01 | `w01_energy.in` | Does `p1.exe` run with only `cygwin1.dll` next to it? Which version is it (the file is dated 2021)? | Banner (version, date); `converged!`; E = t01? | running.md (Windows); about.md (versions) | |
| w02a | `w02_scratch_default.in` | `disk=1`, no `path=`, `TMPDIR` unset: does the run stop at `opening file /tmp/...`, and where does `Disk:` point? | `Disk:` echo; where the output stops | running.md (scratch on Windows); common-problems (`/tmp` on Windows); `system.path` | |
| w02b | (same) | `set TMPDIR=%TEMP%` in cmd.exe | `Disk:` echo; runs? | running.md | |
| w02c | (same) | `set TMPDIR="%TEMP%"` (with the quotes, as in the forum recipe in running.md) | `Disk:` echo; runs? Do the quotes break it? | running.md (parallel recipe, step 5) | |
| w02d | (same) | `TMPDIR` set to a Windows path (`C:\...\w02d_tmp`) | `Disk:` echo (converted to `/cygdrive/...`?); runs? | running.md | |
| w03 | `w03_ramdisk.in` | `disk=-256` (RAM disk), no `path=`, `TMPDIR` unset: does that avoid the `/tmp` problem? | Runs?; `Disk:` echo | `system.disk`; common-problems | |
| w04 | `w04_no_system.in` | No `$system` group, `TMPDIR` unset: does a beginner's input run? | Runs?; `Memory:` echo | getting-started; `system.memory` | |
| w05a | (w01) | Basis path with backslashes, `basis=C:\...\basis.in` | Runs? | running.md (basis path) | |
| w05b | (w01) | Basis path with forward slashes, `basis=C:/.../basis.in` | Runs? | running.md | |
| w05c | (w01) | Relative `basis=basis.in`, the file next to the input | Runs? | running.md | |
| w06 | (w01, CRLF) | Input with Windows line endings: does the Windows build cope, or does it fail as on Linux? | `molecule input: ''`, `?rtesian` or a normal run | input-syntax; common-problems (CRLF) | |
| w07 | `w07_memory_3gb.in` | `mem=3000`: no `malloc(...) failed` in the 64-bit build? | `Memory:` echo; runs? | running.md (1 GB limit of 32-bit builds) | |
| w08 | (w01, no output file) | Does the output go to the console? | `w08_stdout.stdout` | running.md | |
| w09 | (w01) | Started from another folder with full Windows paths for input and output | Runs? | common-problems (`cannot open input file`) | |
| w10a | (w01) | Run inside a folder whose name has a space | Runs? | running.md (no spaces in names) | |
| w10b | (w01) | Run from outside, quoted relative paths with a space | Runs? | running.md | |
| w11 | `w11_optimize.in` | Water optimization (`path=.`) | `OPTIMIZATION CONVERGED`; final E | running.md | |
| w12 | `w12_hessian.in` | Water analytic Hessian (`path=.`) | Frequencies; same as Linux v25? | running.md | |
| w13a | (w01) | `p_190306.exe` on 2 processes through `MPIRUN` | Process lines; E = t01? | running.md (parallel runs on Windows) | |
| w13b | (w01) | `p_190306.exe` started directly, without a launcher | Runs serially, or fails for lack of MPI? | running.md | |

At the end `status.txt` lists scratch files left in the run folder and whether a `tmp` folder appeared next to the
program's folder (where Cygwin without an installation puts `/tmp` *(inferred)*).

## Still not covered

PBS/Torque scripts, `$d2edr2` numerical
Hessians and the split `num>` workflow, and the remaining undocumented tasks (`extremal`, `transit`, `saddle`, `path`,
`conical`, `anharmonic`, `opt_n1`, `thermostat`, `uniq`), which need two-geometry inputs or long runs.
