# Priroda manual: plan

Status: research done (`research/00–07`). The toolchain, the merged keyword reference, Part I and Part V are written.
The structural model comes from `research/07_qc_manual_structures.md` §3. The content inventory comes from the research notes.

## 0. Decisions (settled 2026-10-16)

| # | Decision | Outcome |
|---|---|---|
| D1 | Language | **English only for now.** Prose fields in the keyword YAML are `{en: ...}` dicts, so another language can be added later without a schema change. |
| D2 | Target version | Current Priroda (v23 / 2025 builds from p_w/). Older behaviour goes into "Version differences" notes. |
| D3 | Toolchain | Sphinx + MyST Markdown + Furo, `sphinxcontrib-bibtex`. The PDF is built with pdflatex and Computer Modern (OT1), because this machine lacks `texlive-xetex`, `texlive-luatex` and `texlive-fontsrecommended`. Non-ASCII symbols are mapped in `latex_elements`, and the visible text must stay free of Cyrillic. Switch to XeLaTeX once `texlive-xetex` is installed. `docs/reference/` is generated from `keywords/*.yaml`. |
| D4 | Verification | The user will run Priroda **later**. Until then every keyword carries `verified_against: null` (rendered "not verified"). |
| D5 | Developer review | Approved in principle. The user makes contact; we prepare the defaults table and the list of undocumented keywords. |
| D6 | Presentation (2026-10-17) | The manual states on its front page and in About that it is **unofficial**, and lists its sources on a Sources page. The prose never says "the author": write "the developer", "Laikov", "the official site" or "`input.txt`". No error-message index. No placeholder pages: the toctree has only written chapters, and parts are numbered by what exists (renumber when Part II/III chapters arrive). The PDF is one-sided (`openany,oneside`) so it has no blank pages. |

## 1. Outline

Every Part II chapter follows one template: *Overview → Minimal input → Key options → Advanced → Pitfalls (from forums) → Keyword summary (links into Part IV) → References.*

**Part I: Introduction** (built as Part I)
1. About Priroda: history (Laikov; versions 2 → 23), capability matrix (rows: tasks; columns: `dft`, `ridft`, `DFT_n4`, `tddft`, `rimp2`, `ccsd`, `ccsd4t`, `qm_n3`; marks for `four=1` and MPI), **what Priroda does not do** (symmetry, continuum solvation, D3, periodic systems), how to cite. ("Obtaining Priroda" moved to Getting started, 2026-10-17: download from p_w/, or e-mail the developer.)
2. Installation and running: Linux binaries (`p`, `p4`, `_d` variants, cluster builds), `p in out`, `p -np N in out`, Windows/Cygwin (`p1.exe`, `p.exe` + OpenMPI DLLs, `dev\shm`), PBS/SLURM job scripts, `$system` (per-process `memory`/`disk`, negative disk = RAM disk, `mem=a,b` for rank 0 vs the other ranks, `path=`/`$TMPDIR`, never NFS), LF line endings.
3. Getting started (was "Quickstart"): obtaining Priroda (official site downloads) → water energy → NH3 optimize+hessian → reading `MOL>`/thermo output. Uses the 14-step beginner loop from `06` §5.
4. Input syntax: `$group … $end`, case-insensitive, unique-prefix abbreviation, indexed arrays `a(5)=…`, multi-value `tol=a,b`, flag strings `print=+a+b`, ordered `$molecule` data, the commenting convention (drop the `$`), restart blocks appended to input (`$Energy` / `eng>`, `num>`).

**Part II: Typical calculations**
5. Single points: DFT vs riDFT, **the hybrid trap** (hybrids silently lose exact exchange outside `theory=ridft`), functionals, grids.
6. Geometry optimization: internal vs `cartesian=1`, `tol`, `trust`, `fix`/`value`, `opt_n1` for large systems, the restart loop (`gm` script).
7. TS, IRC, scans: scan → hessian → `saddle=1` with the Hessian in the input → IRC both directions (`back=`) → re-optimize endpoints. Covers 1D/2D scans, the inverted dihedral sign, `transit`/`path`/`conical` (status to be verified).
8. Hessians, frequencies, thermochemistry: analytic vs `$d2edr2` numerical, distributed numerical Hessian via `num>`, `$thermo`, reading H/G from the "total" row, the monoatomic RT, Raman via `task=dipole`, anharmonic.
9. Correlated methods: RI-MP2, CCSD, CCSD(T); frozen core (`$atoms core/mcore`), `$integral direct=1`, memory/disk sizing, known MPI hang.
10. Scalar-relativistic `four=1`: `nucleus=finite`, `basis4.in`/`b4s*.in`, point- vs finite-nucleus basis compatibility.
11. NMR: `task=nmr` (only with `theory=dft`), `standard(Z)` tables, NICS via `$nmr points=`/dummy atoms.
12. Excited states: TDDFT, `state=m,n`, fluorescence workflow; no hybrid TDDFT.
13. Properties: Hirshfeld/Mulliken charges, bond orders, ESR, `print=+density` critical points, orbitals to Molden.
14. Semiempirical QM model (`qm_n3`, `qm.in`; elements covered) and MD (`thermostat`, `$dynamic`), conformer filtering (`uniq`, `$uniq`).
15. Parallel performance and tuning: scaling limits (6–8 cores per node, no gain across nodes), disk speed, per-process paths.

**Part III: Methods and theory** (short, ORCA-style)
16. Density fitting. 17. Functionals table. 18. Basis-set families: Λ/L (L0…L7777, m/a/+ variants, Lx, `_k`), 3z, SBK, b2/b2u/b4s, and orbital ↔ auxiliary pairing. 19. Adaptive grids. 20. Scalar-relativistic Hamiltonian. 21. Optimizer and coordinates. 22. QM model.

**Part IV: Input reference** (currently built as Part II; one chapter per group, in input-writing order, generated from YAML)
`$system`, `$control`, `$molecule`, `$guess`, `$scf`, `$dft`, `$grid`, `$integral`, `$atoms`, `$optimize`, `$d2edr2`, `$thermo`, `$nmr`, `$dynamic`, `$uniq`, `$Energy`, basis-file format (`$kinetic`, `$auxiliary`, ECP, gc). Includes a master group table and an alphabetical index.

**Part V: Troubleshooting** (currently built as Part III)
23. Solving common problems (symptom → cause → fix): SCF divergence, optimization failures, NaN/missing basis, memory/disk errors, MPI hangs.
24. ~~Error-message index~~ Dropped (D6). Verbatim messages stay in the symptom entries of chapter 23.
25. Version differences and obsolete keywords (the old `$SCF`/`$search`/`$force` names from `Dft_ansi.txt`, and how the defaults changed).
26. FAQ.

**Appendices:** Sources (written). A. Example inputs (+ expected energies if D4 allows). B. Output markers (`MOL>`, `eng>`, `freq>`, `mos>`, `num>`, `<$molecule`, `OPTIMIZATION CONVERGED`, `REACTION PATH`, …). C. Helper scripts (`ge`, `gm`, `grx`, pri2mol, xyz2pri; we write generic replacements for the KNC-only `lastgeo`/`lasteng`). D. Units/constants. E. Bibliography.

## 2. Keyword record

Follow 07 §3.2. The fields that matter most for Priroda:
- anchor `group.keyword`, because `steps` exists in both `$optimize` and `$d2edr2`;
- `status`: current, undocumented, deprecated or removed;
- `sources`: list of research-note refs;
- `verified_against`: program version, or `null`;
- `default` with the conditions it depends on (e.g. functional default depends on `theory`).

## 3. Known conflicts

"Recorded" means the YAML uses the best evidence as the default and states the conflict in `default_note`/`notes`.
Every item stays open for D4, testing against a real binary.

| Item | Values seen | Resolution |
|---|---|---|
| `$scf iterations` default | 30 (Dft.rtf), 48,16 (HF for CCSD, 05), 16,16 (v6/v13/v15 output) | **v25: `32,16`** (08 t01). Recorded; older values in the note |
| `$grid accuracy` default | 1e-7 (Dft.rtf), 1e-8 (input.txt), 1e-8,1e-5 (output) | **Confirmed in v25** (08 t01) |
| Grid finer than 1e-8 | useful (input.txt) vs pointless (Dft.rtf) | Both stated; test |
| `$optimize trust` default | 0.5 (Dft.rtf), 0.2/0.0125 (output) | **v25: `0.125,0.015625`** (08 t11). Recorded; older values in the note |
| `$control task` default | `gradient` (Dft.rtf, pri script) | **Confirmed in v25** (08 t02) |
| `$control theory` default | `dft` (Dft.rtf) | **Confirmed in v25** (08 t02) |
| `sbk.bas` coverage | Z≤84 (Dft.rtf), Z≤86 (file) | Recorded Z≤86 in `control.basis` |
| `rL*` basis names | limor1 only | Probably a local rename; official `basis4.in` uses `L1…`. Settle in the basis chapter |
| `convergence`+`iterations` in `$scf` | parser error `erations` (05); no effect without `procedure=bfgs` (04 #324) | **v25: `convergence=… iterations=…` gives `unknown name terations`; works with a keyword between** (08 t07). Safe orders: tests round 2 (t22) |
| `$optimize steps` vs `step` | v6: `step` wins if both given | Recorded |
| `functional` group | `$scf` (Dft.rtf) vs `$dft` (input.txt) | `$dft` is current |
| `$atoms core(280)` index layout | 10·Z apparently | **Confirmed 10·Z** (08 t16) |
| `$optimize coordinated=` spelling | input.txt typo? | **Typo confirmed**: `unknown name coordinated` (08 t40b); the binary reads `coordinates` (09) |
| `$molecule mult` meaning | one forum post used `-1 1` for a radical anion (04 #49) | **Confirmed 2S+1** (08 t10) |
| Undocumented tasks and theories | 03, 01 | v25: the 12 ab initio theories in t17 and `task=check` run (08). Rest: tests round 2 |
| Old predecessor keywords (`$SCF shift/field/fit`, `$search`, `$force`) | Dft_ansi.txt only | Not in the YAML. Goes to the "Version differences" chapter |
| QM-specific `$scf d=, p=, dir=` (qm_n2) | 01 §4.5, meaning unknown | Not in the YAML until understood |

## 3a. Checklist for the first test runs (D4)

Questions that a single run can answer. They are also tagged `<!-- verify -->` at the relevant place in `docs/`.
`tests/` holds the minimal inputs for them, with a run script and a results table (`tests/README.md`). Round 1 ran on
Priroda 25 (2025.02.28) on 2026-10-17 (rounds 1–4); results in `research/08_test_runs_v25.md`. Answered: 1 (bundled
`mpiexec`; `p -np` rejected), 2 (partly: `/tmp` echoed), 3 (serial, cwd), 4, 5, 6 (aborts silently for `dft`, runs
wrongly for `tddft`), 7 (yes; the last `$Energy` group wins), 8 (imaginary as `845.22i`), 9 (not detected),
10 (only `mol>`), 11, 12, 13 (the common theories run; unknown names run HF), 14 (no such line printed). Still open: 15
(Windows).

1. Parallel launch: `p -np N in out`, or `./mpiexec -np N ./p in out`, or `mpiexec -np N p in`?
2. Scratch directory when neither `path=` nor `TMPDIR` is set: the current directory, the input-file directory, or `/tmp`?
3. Does a relative `basis=` name resolve (against the current directory or the input directory)?
4. Can two groups share one line? Is a text-only `$` group (the commenting convention) silently ignored?
5. Unknown keyword: is the result `*** error in '$group' : unknown name …`? Does `convergence` + `iterations` in `$scf`
   trigger the `erations` error, and does `procedure=bfgs` matter?
6. `theory=dft` with `functional=PBE1`: in v23, does exact exchange get silently dropped, or does the run abort?
7. Does `task=energy` print an `eng>` block? With several `$Energy` groups in an input, which one is used?
8. The exact frequency-table format and how imaginary frequencies are shown; the `ZPVE` line; the default
   temperature (298.000 vs 298.150).
9. Is the rotational symmetry number detected automatically, or must `sigma=` always be given?
10. Is the last geometry of an unconverged optimization printed (`mol>` lines)?
11. Defaults echoed in the output: `scf options`, `grid: accuracy`, `Trust radius`, `Maximum number of steps`, and
    the default `task`/`theory`.
12. `$atoms core(10·Z)` layout; `$optimize coordinates=` vs `coordinated=`; `$molecule mult` meaning.
13. Each undocumented `task=`/`theory=` value in `keywords/control.yaml`: does it run at all?
14. Is "performance will be degraded terribly…" printed by the program, or only a sentence in `input.txt`?
15. The Windows build: the current file names in `exe64/`, and the Cygwin/OpenMPI DLLs it needs.

## 4. Work order

1. ~~Settle D1–D5.~~ Done.
2. ~~Scaffold the toolchain and the YAML schema; migrate the `input.txt` keywords as the baseline.~~ Done: 13 groups, 52 keywords. The `$integral`, `$guess mix` and `task=extremal` entries were recovered from 03 #0 because their annotations in `input.txt` are corrupted.
3. ~~Fold in the keywords and defaults from the other sources; record the §3 conflicts.~~ Done: 16 groups, 72 keywords. New groups are `$Energy`, `$dynamic` and `$uniq`, with undocumented tasks, theories, functionals and print flags marked per value.
4. ~~Write Part I and the Part V error index.~~ Done: About, Running, Quickstart and Input syntax; Common problems. The error index
   was written and then dropped (D6). The open questions are in §3a.
4a. ~~First round of test inputs for §3a.~~ Done: `tests/`, run on v25; findings folded into the YAML and Part I/III.
4b. ~~Second round of test inputs (t21–t40).~~ Run on v25; folded into `research/08`, the YAML and the chapters.
4c. ~~Third round (t40b–t49).~~ Run on v25; folded in. t21 still needs an MPI launcher.
4e. ~~Keyword list from the v25 executable (`p4_d`).~~ Done: `research/09`, appendix page "Keywords in the program";
    YAML names corrected (`optimize.symmetry`, `optimize.model`, `uniq.distance`).
4f. ~~Round 4 (t21, t41b, t50, t53, t55, t56, t57).~~ Run on v25; folded in. Parallel launch settled (bundled `mpiexec`).
4g. ~~Round 5 (t58–t63).~~ Run on v25; folded in. Remaining `verify` marks need Windows, a batch system or hard cases.
4d. Repository `README.md` added.
5. Write the Part II chapters in task order, then Part III, then the appendices.
