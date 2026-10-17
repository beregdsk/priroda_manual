# Local source files (`priroda_man/`)

Three pre-existing documents, all predating this project. Treat `priroda_man/` as read-only originals; UTF-8 copies live in `research/`.

| File | Language / encoding | What it is | Era |
|---|---|---|---|
| `priroda_man/input.txt` | English, ASCII | "Input Summary" — closest thing to an official keyword reference, apparently Laikov's own text with user annotations appended. | Newest (Priroda with `$system`, `$dft`, `$optimize`, riMP2/CCSD, `four=1`) |
| `priroda_man/Dft.rtf` | Russian, RTF cp1251 → `research/00_Dft_rtf_utf8.txt` | "ИСХОДНЫЕ ДАННЫЕ ДЛЯ ПРОГРАММЫ “ПРИРОДА” автор Др. Д.Н.ЛАЙКОВ" — short user-annotated keyword list with practical advice. | Middle (has `$molecule`, `$optimize`, `$scf functional=`, basis files `3z.bas`, `sbk.bas`, `ccpvnz.bas`) |
| `priroda_man/Dft_ansi.txt` | Russian, cp1251 CRLF → `research/00_Dft_ansi_utf8.txt` | "Описание исходных данных" for the predecessor program (groups `$coordinates`, `$basis`, `$auxiliary`, `$SCF`, `$search`, `$force`, `$hessian`). | Oldest — mostly obsolete keyword names; useful for history and for the inline basis-set format. |

## Corruption in `input.txt`
Lines 60–61, 75, 127–128, 419–421 were Russian user annotations whose Cyrillic was lost to `?` (unrecoverable from this file). Recoverable meaning from context:
- `task=extremal` — an undocumented task type (annotation lost; possibly search for extremal/stationary points of some kind — **verify from other sources**).
- `$guess mix=1` — mixes HOMO/LUMO to break alpha/beta symmetry for an unrestricted start (cf. old `$SCF mix` in `Dft_ansi.txt`).
- `$integral direct=1 routine=2` — `direct=1` enables direct (no-disk) integral evaluation for `theory=riMP2` and `theory=riDFT`; `routine=0|1|...` selects an integral-evaluation routine (0 default; 1 faster but ...).

## Key facts from `input.txt` (newest)
Syntax: NAMELIST-like free format, `$group ... $end`, case-insensitive, keyword names abbreviable to any unique prefix, arrays with start index `na(85)=86,85`.

Groups documented: `$system` (memory MB, disk GB or negative = RAM-disk MB, path incl. colon-separated per-process paths, never NFS), `$control` (task, theory, state, basis, four, nucleus, print, save), `$guess` (read, na/nb reordering), `$dft` (functional: PBE default, mPBE, BLYP, OLYP, PBE1 default for riDFT, B3LYP_PW, B3LYP — with Laikov's note that Becke used PW not VWN), `$scf` (restrict, convergence=1e-6,1e-3, iterations, procedure nr|bfgs, d1small, core), `$atoms` (core shells per Z, e.g. `core(280)=2,1,0,0` for Ni — index looks like 10·Z, unverified, mcore), `$grid` (accuracy 1e-8 default), `$optimize` (saddle, tolerance 1e-4,1e-2, trust, follow, steps 50, cartesian, back, points, radius, coordinates 5-int tuples incl. types 4/5 for linear fragments, fix, value, gradient, print), `$thermo` (sigma, temperature up to 50), `$d2edr2` (length, displace 1|2, steps for split/parallel numeric hessian with `grep "num>"` merge recipe), `$nmr` (standard per Z, points), `$molecule` (charge, mult, cartesian|z-matrix, mass=, mixed cart+zmat, `set=` per-atom basis), `$integral` (see above).

Tasks: energy, gradient, hessian, optimize, irc, scan, nmr, dipole (+ undocumented extremal). Theories: dft, ridft, tddft, rimp2, ccsd, ccsd4t, others undocumented.
Print options: `+charges` (Hirshfeld), `+bonds`, `+esr`, `+vectors`, `+molden`.

## Extra facts only in `Dft.rtf`
- Defaults differ from `input.txt` in places: `memory=16`, `disk=1`, `accuracy=1e-7`, `iterations=30`, `trust=0.5`, `radius=0.2`, `functional=PBE` placed in `$scf` (older location; `input.txt` has it in `$dft`). Conflicts must be resolved against the current program, not copied blindly.
- `disk`: one file per GB to dodge per-file size limits.
- `task=check` (geometry only), combined `task=optimize+hessian`; `irc` coordinate in bohr·amu^1/2.
- Basis files: `3z.bas` (all-electron, up to Z=54), `sbk.bas` (SBK ECP, scalar-relativistic, up to Z=84), `ccpvnz.bas` (for MP2, aux sets for `set=2z|3z|4z` = cc-pVDZ/TZ/QZ).
- Molden workflow: `grep "freq>" file.out` → strip `freq>` → `molden file.freq`; same with `mos>` for orbitals.
- `$hessian` required for `saddle=1`, `task=irc`; author advises computing a hessian before difficult optimizations.
- Advice: don't raise `steps`/`iterations` — non-convergence means something is wrong; NR SCF can recover from a wrong configuration but may blow up, then try `proc=BFGS`; grid 1e-6 for rough (`tol=1e-3`), 1e-8 for floppy molecules to `tol=1e-5`, beyond 1e-8 pointless.
- `$thermo mass=`, `sigma=1`, `temperature=298.15,...`.

## Extra facts only in `Dft_ansi.txt` (predecessor)
- Inline `$basis` format: `[Z] [n radial fns]` then per shell `[L] [n prims]` + exponent/coefficient pairs; `$auxiliary`: uncontracted spherical Gaussians, `L+` means all L' ≤ L.
- `$SCF field()` external uniform electric field (au); `shift` level shift (0.5 default; 1.5–2.5 for low-lying excited states); `fit`, `mix`.
- `$search` 2D scans (`iscan/jscan`, `ivalue/jvalue`), explicit `vector`/`curvature` for TS search; `$force points/delta` (delta 0.0025 needs conv 1e-6).
These may or may not survive in current Priroda — check before documenting.
