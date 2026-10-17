# Verification inputs (first round)

Small inputs that each answer one open question in the manual. Everything uses water or ammonia with the `L1` basis
from `basis.in`, so each run takes seconds to minutes on one core. The questions come from `PLAN.md` §3a and the
`<!-- verify -->` marks in `docs/`.

## How to run

```bash
PRIRODA=/path/to/p BASIS=/abs/path/to/basis.in ./run.sh          # everything
PRIRODA=/path/to/p BASIS=/abs/path/to/basis.in ./run.sh t01 t08  # selected tests
```

`run.sh` fills in `@BASIS@` (and `@THEORY@` for t17), runs each input serially into `runs/<date>/`, and writes each
exit status to `runs/<date>/status.txt`. Note the Priroda version and build date from the output banner. Every
answer is recorded against that version.

After a run, record the answer in the last column below. Then update the keyword YAML (`default`,
`verified_against`, `status`) or the chapter text, and remove the `<!-- verify -->` mark it resolves.

## Tests

| ID | Input | Question | What to look at in the output | Where it is used | Result |
|---|---|---|---|---|---|
| t01 | `t01_energy.in` | Baseline: does the documented water example run? Is an `eng>` block printed for `task=energy`? | Banner and version; `converged!`; final energy; Hirshfeld charges and bond orders; any `eng>` lines | getting-started (water); PLAN 3a.7 | |
| t02 | `t02_defaults.in` | Defaults when `task`, `theory` and `$system` are all omitted | Which task and theory ran; `Memory:` and `Disk:` lines; scratch directory; `scf options:`, `grid: accuracy` echo lines | `control.task`, `control.theory`, running.md (`$system` defaults, scratch location); PLAN 3a.2, 3a.11 | |
| t03 | `t03_relative_basis.in` | Does a relative `basis=basis.in` resolve when the file is in the working directory? | Normal run, or a basis-file error | `control.basis`; common-problems (basis not found); PLAN 3a.3 | |
| t04 | `t04_shared_line.in` | Can two groups share one line? | Does `scf options:` show `conv=1.0e-07`, and does the grid echo show `1e-9`? | input-syntax (groups); PLAN 3a.4 | |
| t05 | `t05_disabled_group.in` | Are text outside groups and a disabled group (`integral dir=1 $end`, no `$`) with its stray `$end` ignored? | Normal run with no complaint | input-syntax (text outside groups); PLAN 3a.4 | |
| t06 | `t06_unknown_keyword.in` | What happens with an unknown keyword? | Expected form: `*** error in '$scf' : unknown name ...` | input-syntax (keywords); PLAN 3a.5 | |
| t07a | `t07a_conv_iter.in` | Do `convergence` and `iterations` together in `$scf` trigger `unknown name erations`, or get ignored? | Error message, or the values in `scf options:` | `scf.convergence`; common-problems (`$scf` settings ignored); PLAN 3a.5 | |
| t07b | `t07b_conv_iter_bfgs.in` | Same, with `procedure=bfgs` between them | `scf options:` line | as t07a | |
| t08 | `t08_hybrid_with_dft.in` | `functional=PBE1` with `theory=dft`: is exact exchange silently dropped, or does the run abort? | Error message, or the functional/exchange lines and the energy (compare with a `theory=ridft` run if needed) | about.md warning; `control.theory`; PLAN 3a.6 | |
| t09 | `t09_real_atomic_number.in` | Atomic numbers written as `8.0`: is the error `molecule input: ''` and `illegal charge/multiplicity`? | The error lines | common-problems (`molecule input: ''`) | |
| t10 | `t10_multiplicity.in` | Is `mult` the multiplicity 2S+1 (OH radical, `mult=2`)? | Runs unrestricted with one unpaired electron | `molecule.mult`; PLAN 3a.12 | |
| t11 | `t11_optimize.in` | The documented NH3 optimization | `OPTIMIZATION CONVERGED`; `MOL>` lines; that the `sed` recipe in getting-started extracts a usable geometry | getting-started (steps 1-3) | |
| t12 | `t12_optimize_unconverged.in` | Is the last geometry printed when an optimization stops at `steps`? | `MOL>` or `mol>` lines at the end; the message printed at the step limit | getting-started; PLAN 3a.10 | |
| t13 | `t13_hessian.in` | Frequency table format, imaginary frequencies, ZPVE line, default temperature, rotational symmetry number | `Normal Mode` table; `ZPVE`; the `T =` line (298.000 or 298.150); whether a symmetry number is detected without `sigma=`; `freq>` lines | getting-started (steps 4-7); `thermo.temperature`, `thermo.sigma`; PLAN 3a.8, 3a.9 | |
| t14 | `t14_optimize_hessian.in` | Does `task=optimize+hessian` work in this version? | Optimization followed by frequencies in one output | getting-started (one-run alternative) | |
| t15 | `t15_symmetry.in` | What do `$molecule sym=1,0.01` and `$optimize sym=1` do? | `symmetry:` line; compare the steps and timing with t11 | `molecule.sym`, `optimize.sym`; about.md | |
| t16a | `t16a_mp2_default_core.in` | RI-MP2 runs; default frozen core | Number of core electrons or frozen orbitals reported | `atoms.core` | |
| t16b | `t16b_mp2_atoms_core.in` | Is the `$atoms core` index `10·Z` (here `core(80)` for O)? | Core count differs from t16a (0 instead of 1s), or an error | `atoms.core`; PLAN 3a.12 | |
| t17 | `t17_theory_template.in` | Which undocumented `theory=` values run at all? `run.sh` makes one input per value: `hf rihf cis mp2 mp3 mp4dq mp4sdq mp4sdtq ccs ccd ccsd ccsd4t` | Normal end and an energy, or an error | `control.theory`; PLAN 3a.13 | |
| t18 | `t18_task_check.in` | Does undocumented `task=check` process the geometry only? | Output stops after the geometry | `control.task`; PLAN 3a.13 | |
| t19 | (t01, output `T19_Capital.out`) | Does a capital letter in the output file name cause `output file '...'?` | That message | running.md; common-problems (file names) | |
| t20 | (t01, no output file) | Does the output go to standard output when no output file is given? | `t20_stdout.stdout` | running.md | |
| t21 | (t01 on 2 processes) | Which parallel launch works: `p -np 2 in out` (t21a) or `./mpiexec -np 2 ./p in out` (t21b, if `mpiexec` sits next to `p`)? | Both outputs; same energy as t01 | running.md (parallel runs); PLAN 3a.1 | |

## Follow-ups that need an earlier output

- Several `$Energy` groups: append the `eng>` blocks of two optimization steps from t11 to a copy of `t13_hessian.in`
  (strip the `eng>` prefix) and check which block is read. Question from input-syntax.md and PLAN 3a.7.
- Restart from saved vectors: add `save=` to t01's `$control`, then rerun with `$guess read=1` and
  `$scf iterations=10`. Checks the restart recipe in common-problems.

## Not covered in this round

The Windows build (PLAN 3a.15), batch-system scripts, `four=1` with `basis4.in`, TDDFT, NMR, IRC and scans, and the
undocumented tasks other than `check` (`extremal`, `transit`, `saddle`, `path`, `conical`, `anharmonic`, `opt_n1`,
`thermostat`, `uniq`). These need larger or two-geometry inputs and belong in the next round.
