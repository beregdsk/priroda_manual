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

## Round 1 (run 2026-10-17 on version 25, outputs in `runs/20261017-121135/`)

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

## Round 2 (not run yet)

Small inputs again (water, ammonia, OH), except t32b, t33 and t36, which may take a few minutes.

| ID | Input | Question | What to look at in the output | Where it is used | Result |
|---|---|---|---|---|---|
| t21 | (t01 on 2 processes) | Rerun of the parallel launch, now with stderr kept. Which form works: `p -np 2` (t21a), the bundled `mpiexec` (t21b), or a system `mpirun` (t21c)? | `t21*.stdout` for error text; the process lines at the top of each output; same energy as t01 | running.md (parallel runs); PLAN 3a.1 | |
| t22a | `t22a_scf_conv_last.in` | Is `iterations=250 convergence=1e-7` (convergence last) read correctly? | `scf: conv = …; iter=…` line, or an error | `scf.convergence`; common-problems (`$scf` settings) | |
| t22b | `t22b_scf_conv_own_line.in` | Does a line break end the value list (`convergence` and `iterations` on separate lines)? | as t22a | as t22a | |
| t22c | `t22c_scf_conv_two_values.in` | Does `convergence=1e-7,1e-3 iterations=250` give the forum error `unknown name erations`? | Error text | as t22a | |
| t23 | `t23_ampersand_group.in` | Is a group opened with `&` (`&dft func=BLYP $end`) read? | `Approximation to E(xc)` in the summary box: BLYP or PBE | input-syntax (text outside groups) | |
| t24 | `t24_hessian_planar_nh3.in` | Planar NH3 is the inversion transition state. How is the imaginary frequency printed? | Frequency table; the first mode | getting-started (step 5); limor1 scripts expect an `i` suffix | |
| t25 | `t25_saddle_from_hessian.in` | TS optimization with `saddle=1` and the t24 Hessian appended as `$Energy`. Is the Hessian read? | A message about reading the Hessian; steps; `OPTIMIZATION CONVERGED`; planar final geometry | `optimize.saddle`, `Energy.H`; input-syntax (`$Energy`) | |
| t26 | `t26_irc_from_hessian.in` | IRC from the planar TS with the t24 Hessian, `points=10` | Path points, energies, the final message; one or both directions | `control.task` (irc), `optimize.points`, `optimize.back` | |
| t27a/b | `t27a_save_vectors.in`, `t27b_read_vectors.in` | Does `save=` write vectors, and does `$guess read=1` read them? | t27b: initial guess line and fewer SCF iterations than t27a | `control.save`, `guess.read`; common-problems (SCF restart) | |
| t28a | `t28a_oh_more_iterations.in` | Does the OH radical of t10 converge with `iterations=100`? | `converged!` and the iteration count | common-problems (SCF) | |
| t28b | `t28b_oh_bfgs.in` | Same with `procedure=bfgs` | as t28a | `scf.procedure` | |
| t29 | `t29_mol_block_charge.in` | Does the final `MOL>` block repeat `charge=-1` for OH⁻? | The `MOL>` lines | getting-started (step 2) | |
| t30a | `t30a_molecule_sym_only.in` | What does `$molecule sym=1,0.01` alone do? | `symmetry:` lines; `Coordinates:` in the optimizer echo | `molecule.sym` | |
| t30b | `t30b_optimize_sym_only.in` | What does `$optimize sym=1` alone do? | as t30a | `optimize.sym` | |
| t31a | `t31a_ridft_default_functional.in` | Is PBE1 the default functional for `theory=ridft`? | `Approximation to E(xc)` | `dft.functional` | |
| t31b | `t31b_ridft_pbe1.in` | Hybrid energy with `ridft` + `PBE1` (the correct way) | Normal end, energy | about.md hybrid warning | |
| t32a | `t32a_hessian_ridft.in` | Does `task=hessian` work with `ridft` (analytic or numerical)? | Hessian heading; frequencies | about.md capability matrix (`?` cells) | |
| t32b | `t32b_hessian_rimp2.in` | Same with `rimp2` | as t32a; run time | capability matrix | |
| t32c | `t32c_optimize_hf.in` | Do gradients work with `theory=hf`? | `OPTIMIZATION CONVERGED` | `control.theory` notes | |
| t33 | `t33_tddft.in` | GGA TDDFT with `state=1,5` | Excited-state table: energies, oscillator strengths | `control.state`; about.md (TDDFT) | |
| t34 | `t34_nmr.in` | NMR shieldings with `theory=dft` | Shielding table format | `control.task` (nmr), `$nmr` | |
| t35 | `t35_four_relativistic.in` | Scalar-relativistic `four=1` with `basis4.in` (needs `BASIS4`) | `Hamiltonian: scalar-relativistic`; nucleus model; energy | `control.four`, `control.nucleus` | |
| t36 | `t36_task_dipole.in` | `task=dipole` (numerical polarizabilities, for Raman) | What is printed; run time | `control.task` (dipole) | |
| t37 | `t37_scan.in` | Relaxed scan, adapted from the limor1 `NH3_scan-fix` example | One optimization per point; the per-point output marker; the dihedral sign | `control.task` (scan), `optimize.fix`, `optimize.value` | |
| t38a | `t38a_dft_n4_lpbevv.in` | Does `theory=DFT_n4` with `functional=LPBEVV` (2025 official inputs) run? | Method and functional in the summary box; energy | `control.theory`, `dft.functional` | |
| t38b | `t38b_ridft_lpbevvv.in` | Does `functional=LPBEVVV` with `ridft` run? | as t38a | `dft.functional` | |
| t39 | `t39_qm_n3.in` | Semiempirical QM model with `qm.in` (needs `QMBASIS`) | Energy; run time | `control.theory` (qm_n3) | |
| t40 | `t40_coordinated_spelling.in` | Is `$optimize coordinated=` (the `input.txt` spelling) accepted? Any unique prefix of `coordinates` would be. | Error `unknown name coordinated`, or a normal run | `optimize.coordinates` | |

## Still not covered

The Windows build (PLAN 3a.15), batch-system scripts, several `$Energy` groups in one input, `$d2edr2` numerical
Hessians and the split `num>` workflow, and the remaining undocumented tasks (`extremal`, `transit`, `saddle`, `path`,
`conical`, `anharmonic`, `opt_n1`, `thermostat`, `uniq`), which need two-geometry inputs or long runs.
