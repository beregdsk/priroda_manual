# How comparable QC program manuals are organized (survey for the Priroda manual)

Surveyed 2026-10-16 with WebFetch/WebSearch/curl. Programs: ORCA 6.1 (and 6.0 for contrast), GAMESS(US),
TURBOMOLE 8.0, Psi4 (master), NWChem, CP2K, Gaussian 16. Sources are listed at the end. Where a statement is
inferred (e.g. a toolchain from page markup) rather than stated by the docs, it says so.

---

## 1. Per-program summaries

### 1.1 ORCA (FACCTS, 6.1 current; https://www.faccts.de/docs/orca/)

**Two separate products.** The docs hub offers *ORCA Tutorials* and the *ORCA Manual* as distinct sites. The
tutorials say outright that they are the entry point and that "for more detailed documentation, please refer to
the ORCA manual".

- **Tutorials TOC** (task-oriented): First steps (How to cite, Installing, "Hello water! Your first ORCA
  calculation", Input and Output, Running in parallel, Memory settings, GUIs, **Solving common issues**) /
  Workflows (compound jobs, extrapolation, external methods, Python interface) / Properties (single points, opt,
  freq, thermo, solvation, relativistic, dispersion, bond analysis, charges, ESP, ...) / Reactivity (NEB-TS, TS
  optimization, IRC, accurate barriers, KIE, ...) / Spectroscopy (IR/Raman, UV/Vis, ECD, VCD, NMR, EPR, SOC) /
  Multiscale.
- **Manual 6.1 TOC** (restructured in 6.1 "to serve both beginners and experienced developers"):
  Preface (Foreword, Highlights, **How to cite**, **How to use this manual**) → 1 Quickstart Guide →
  2 Essential Calculation Elements → 3 Model Chemistries → 4 Structure and Reactivity → 5 Spectroscopy and
  Properties → 6 Multiscale Simulations → 7 Molecular Dynamics → 8 Workflows and Automatization → 9 Utilities and
  Visualization → 10 Architecture of ORCA → Appendix (detailed change log, publications related to ORCA,
  **Glossary**) → Bibliography & Index.
- **Older 6.0 TOC, for contrast:** General Information / Architecture / Calling the Program (serial and
  parallel) / General Structure of the Input File / Input of Coordinates / **6 Running Typical Calculations** (by
  task) / **7 Detailed Documentation** (59 method sections) / 8 Tips and Tricks / FAQ in the preface. This is the
  well-known "typical calculations + detailed documentation" split. In 6.1 it was replaced by domain chapters,
  each of which follows the same internal pattern.
- **Inside a section** (stated in "How to use this manual"): a short theory outline with references and simple
  examples come first; **keyword lists and advanced examples come later in each section**. Example: §4.1
  Geometry Optimizations = Basic usage → thresholds → initial Hessian → coordinate systems → constraints (with
  examples) → ... → **Optimization FAQs** (questions as headings, e.g. "I can't locate the TS for a reaction
  expected to feature a low barrier, what should I do?") → General notes → **Geometry Optimization Keywords**.
- **Keyword reference format.** Tables at the end of each section, one per input level:
  simple-keyword table (*Keyword | Description*), and per-block tables for `%method` and `%geom`
  (*Keyword | Option/Value | Description*), one row per allowed value. **Defaults sit inside the description
  prose** ("Maximum number of geometry iterations (default max(3N, 50))"); there is no default column. Running
  examples are code blocks with `#` comments that show defaults (`maxIter 500 # default 200`). Admonitions:
  Note / Tip / Important / Warning.
- **Citations.** Numeric bracketed citations ([530]) link to one global Bibliography page, with the full
  reference shown on hover. The "How to cite" page gives the program reference plus a request to cite the
  methods used. **The program itself prints "SUGGESTED CITATIONS FOR THIS RUN"** (essential / high-priority /
  suggested / optional) and writes `orca.bibtex`.
- **Toolchain.** Sphinx with the **Furo** theme, **sphinx-design** cards, Markdown sources (`index.md.txt` →
  MyST, inferred from markup), and a downloadable PDF (`orca_manual_6_1_0.pdf`) generated from the same
  sources. Feedback goes through the ORCA forum.
- **Good ideas:** separate tutorials site; Quickstart chapter; "How to use this manual" page; per-section FAQ
  with questions as headings; keyword tables at the end of each topic, not in one giant appendix; a glossary;
  citations printed by the program at run time.

### 1.2 GAMESS(US) (https://www.msg.chem.iastate.edu/gamess/documentation.html)

**Six plain-text chapters** shipped in the source tarball (also as PDF with an alphabetical group index):

| Section | File | Content |
|---|---|---|
| 1 | `docs-intro.txt` | Overview: citation of the program (top of file), capabilities list, **capability matrix**, history, distribution policy, **Input Philosophy**, input checking, program limitations, restart capability |
| 2 | `docs-input.txt` (~1 MB, 179 groups) | **Input Description**: every `$GROUP` and keyword; "written in a reference, rather than tutorial fashion" |
| 3 | `docs-tests.txt` | Input Examples: summary table of the `exam*.inp` tests. The tests double as installation verification (expected results are embedded in the input comments; `checktst` script) |
| 4 | `docs-references.txt` (~0.5 MB) | **Further Information**: computational and basis-set references plus long how-to essays per method ("How to do RHF, ROHF, UHF and GVB", "MCSCF", "Coupled-Cluster ... references and citations required in publications", "DFT", "Geometry searches and internal coordinates ... practical matters, saddle points, mode following", "IRC", solvation, EFP, FMO, ...) |
| 5 | `docs-prog.txt` | Programmer's Reference: installation overview, running DDI parallel, memory, program limits, source modules, programming conventions, disk files |
| 6 | `docs-hardware.txt` | Hardware specifics, compiler notes |

- **Input Description structure.** It opens with a **master list of all groups, ordered as users write input**
  (molecule/basis/wavefunction → ... → properties → solvation → integrals → FMO ...), with columns
  `name | function | module:routine`. Each group then has a header line with an **applicability condition**
  (`$SCF group  (relevant if SCFTYP = RHF, UHF, or ROHF, required if SCFTYP = GVB)`, `$DATA ... (required)`), a
  prose paragraph on what the group does, sometimes a **"short list of its most important keywords"** (for the
  very long `$CONTRL`), and then keywords.
- **Keyword entry format** (fixed-width text):
  ```
  SCFTYP             specifies the self-consistent field
                     wavefunction.  You may choose from
         = RHF       Restricted Hartree Fock calculation
                     (default)
         = UHF       Unrestricted Hartree Fock calculation
  ```
  Each allowed value goes on its own `= VALUE` line, and **the default is flagged inline with "(default)"**.
  Logical flags are described in prose with "The default is .FALSE.". Related keywords are grouped under a
  divider (`---- The next flags affect convergence rates.`), and keywords are separated by `* * * * *`.
  **Dependency rules** ("Only one of DIIS or SOSCF may be .TRUE.") and small **default tables** that depend on
  run type are placed inline. Cross-references point to other groups ("See $TDDFT") and to Section 4.
- **Tutorial vs reference.** Tutorials are almost absent. The examples chapter and the Section 4 essays carry the
  "how to" material. Section 2 is pure reference.
- **Theory** lives in Section 4 essays mixed with practical hints and reference lists. There is no math typesetting.
- **Citations.** The program citation sits at the top of Section 1. Topic reference lists in Section 4
  include "references and citations required in publications" for CC.
- **Tooling.** Plain ASCII, ~60-column lines. The **`gmshelp <group>` shell script** pages the relevant group
  of Section 2 in a terminal (`gmshelp scf`). A PDF exists. There is no hypertext.
- **Good ideas:** keyword-per-group reference in input order; per-group "relevant if / required if" header;
  "most important keywords" summary for long groups; capability matrix (method × SCF type × {conventional,
  direct, FMO, parallel, EFP, PCM}); a terminal help command; examples that are also tests with embedded
  expected results; the "Input Philosophy" section that formally defines the `$GROUP ... $END` syntax.
  **Weak points to avoid:** no hyperlinks, no search beyond grep, defaults buried in prose, monolithic 1 MB file,
  no structured type/default fields.

### 1.3 TURBOMOLE (8.0/8.1; https://manual.turbomole.org/)

- **TOC (27 chapters):** Preface and general information → Installation → How to run → **Preparing input with
  Define** (the interactive input generator) → then **one chapter per task/method** (structure and AIMD, HF/DFT
  molecular, periodic DFT, response, MP2, CC2, CCSD/(T)/F12, PNO-CC, RPA, GW, vibrational frequencies,
  electron-vibration coupling, NMR, EPR, paramagnetic NMR, Mössbauer, embedding/solvation, properties and
  visualization interfaces, OEP, vibronic spectra) → **25 Keywords in the control file** → **26 Sample
  control files** → 27 test-suite structure.
- **Input format kinship.** The `control` file is keyword-directed with `$keyword` data groups, `#` comments,
  any order, and a mandatory terminating `$end`. Chapter 25 is "a short-hand documentation" of "the most
  important keywords, their possible parameters, default values, and a brief explanation". It is organized as
  general keywords (system specification, start guess, memory, frozen core, other) and then **keywords per
  program module** (dscf/ridft, grad, aoforce, escf, ricc2, relax, statpt, ...).
- **Keyword entry format:** a heading line `$keyword` + italic argument type (*integer, real, char, options,
  none*), then prose with the default inline ("Maximum number of SCF iterations (default: 30)"). Sub-keywords are
  listed under the parent (`$dft` → `functional`, `gridsize`), followed by indented `Example:` blocks and status
  tags such as "—not recommended for use—" and "—for developers only—".
- **Tutorial vs reference.** The method chapters are narrative (how to run, what define asks, theory sketch,
  references). The keyword chapter is the reference, and a separate sample-control-files chapter gives complete
  inputs. The 8.x site adds top-level **Examples**, a **Structure builder** and an **Input generator (wizard)**
  next to the manual, plus a forum link.
- **Toolchain.** Historically LaTeX → PDF (`DOK.pdf`) and latex2html (`DOK.html`/`nodeNNN.html`, still mirrored
  at CSC). 8.x is a custom static site with KaTeX, versioned URLs (`/v8.0/`, `/v8.1/`), a version selector and
  search. LaTeX conversion artifacts are still visible (`$redund\_inp`, "cal O(cal N^4)"), which is a warning
  about converting legacy LaTeX mechanically.
- **Good ideas:** keywords grouped by the module that reads them; argument-type placeholder in the heading;
  explicit "developers only / not recommended" tags; sample-inputs chapter; versioned online manual; online
  input generator.

### 1.4 Psi4 (https://psicode.org/psi4manual/master/)

- **TOC.** *Users' Manual*: Introduction → Installation and Runtime Configuration → **A Psi4 Tutorial** →
  Psithon: structuring an input file → QCSchema → **Theoretical Methods: SCF to FCI** (one chapter per
  method/module: SCF, DFT, DCT, DF-MP2, DLPNO-MP2, MP2-F12, CC, FNOCC, DLPNO-CCSD(T), OCC, PSIMRCC, CI, MCSCF,
  SAPT, ADC, TDSCF, scalar relativistic; plus Capabilities, Notes on Options, Geometry Optimization, oeprop,
  Vibrational and Thermochemical Analysis) → Interfaces → Psithon Functions → Customization → **Appendices**.
  *Programmers' Manual* is a separate part (code style, adding code, test suite, **updating the manual**, ...).
  Indices: general index, module index, search.
- **Method chapter pattern:** header box (**Code author / Section author / Module: Keywords, PSI Variables,
  source dir**), then Introduction/Theory → **Minimal Input** example → Basic Keywords → Advanced Keywords →
  method variants → **Recommendations** (practical advice), with in-text citations.
- **Keyword reference** is **auto-generated from source**. `/*- comment -*/` docstrings in
  `psi4/src/read_options.cc` are scraped into *Keywords by Module* (37 modules) and *Keywords by Alpha*. Each
  entry is a heading (keyword name) + description + bullet fields **Type** (string, integer, double, boolean,
  array, *conv double*), **Possible Values**, **Default** ("No Default" if required). Expert options are grouped
  into "_Expert_" subsections. Method chapters *transclude* the relevant option entries as "Basic/Advanced
  Keywords", so a keyword is written once and appears in several places. Output quantities ("PSI variables",
  e.g. `"MP2 TOTAL ENERGY"`) get their own scraped glossary, by alpha and by module.
- **Appendices:** keywords, basis sets (by family / by element / auxiliary), QCVariables, **test suite and
  sample inputs** (scraped from `tests/*/input.dat`, with `#!` comment lines as captions), DFT functional lists,
  intermediate files, physical constants, **bibliography**. There is no separate FAQ (help goes to the forum).
- **Citations:** label-style `[Lehtola:2019:241102]` (FirstAuthor:Year:Page) links to one bibliography page.
- **Toolchain:** Sphinx (reStructuredText, `doc/sphinxman/source`), MathJax; targets `sphinxman` (full),
  `sphinxmini` (quick, no autodocs), `sphinxpdf` (LaTeX → PDF). A working psi4 build is required because
  keywords, PSI variables and samples are scraped by Perl/Python scripts.
- **Good ideas:** **single source of truth for keywords in the code**; type/default/possible values as
  structured fields; basic/advanced/expert tiers; transclusion of keyword entries into method chapters;
  "Minimal Input" + "Recommendations" bookends per method; code/section author attribution; output-variable
  glossary; samples generated from regression tests (docs that cannot rot silently).

### 1.5 NWChem (https://nwchemgit.github.io/)

- **TOC:** Download/compile → Introduction (**Getting Started**, Architecture) → Functionalities →
  **Top-level directives** → Geometries → Basis sets → ECPs → Relativistic approximations → **Quantum-mechanical
  methods** (HF, DFT, TDDFT, RT-TDDFT, plane-wave, TCE, MP2, CC, MCSCF, GW, xTB) → QM dynamics → hybrid
  (solvation, ONIOM, QM/MM ...) → PES analysis (geometry optimization, Hessians, constraints, NEB) → electronic
  structure analysis → other → MM → Python control → **Examples** (sample inputs, symmetry geometries) →
  **Benchmarks**, **Known Bugs**, **FAQ**, **Tutorials**, Forum → supplementary → interfaces → containers →
  PDF version.
- **Syntax notation is defined once**, in Getting Started: directives in ALL CAPS, keywords lowercase,
  `<variable>` placeholders with a type prefix (`string`, `integer`, `logical`, `real`, `double`), `[ ]` for
  optional entries with defaults, `( a || b )` for exclusive alternatives, `\` for continuation, `...` for
  repetition, and the case-insensitivity rule.
- **Directive entry format:** a subsection per directive. It starts with a formal **syntax block**, e.g.
  `GRID [(xcoarse||coarse||medium||fine||xfine||huge) default medium] \`, then prose that repeats the default,
  sub-keywords, and short examples. Each module page ends with a numbered **References** list (authors, title,
  journal, year, DOI) linked from footnote markers.
- **Toolchain:** **MkDocs + Material theme** (generator meta `mkdocs-1.6.1, mkdocs-material-9.7.6`). Markdown
  sources live in the `nwchem-wiki` GitHub repo with "Edit this page" links. A PDF is generated separately. This
  is the result of migrating an old wiki.
- **Good ideas:** one formal grammar for syntax blocks; Known Bugs page; FAQ; Benchmarks; edit-on-GitHub links;
  low-friction Markdown authoring.

### 1.6 CP2K (https://manual.cp2k.org/)

- **Two layers in one Sphinx site:** hand-written docs (Getting Started, **Methods**, Technologies, Development,
  Releases) and a fully **auto-generated Input Reference**, a tree mirroring the input section nesting
  (`CP2K_INPUT/FORCE_EVAL/DFT/SCF`) with breadcrumbs. It is generated from the input-definition code
  (`input_cp2k_*.F`), so it is always complete and versioned per release (2.1 … 2026.x).
- **Keyword entry fields:** name (with permalink anchor), **Type** (real/integer/logical/string/enum),
  **Default**, **Aliases**, **Lone keyword** value (value used when the keyword is given without an argument),
  **Usage** (syntax example, e.g. `EPS_SCF 1.e-6`), **Description**, **Valid values** (enum list, each
  described), **References** (bibliography keys), a **source-code link** (`input_cp2k_scf.F#L177`), and
  **"Mentions"** (back-links to the how-to pages that use this keyword). Section pages also show repeatability
  and subsections.
- **Citations:** keywords and methods carry bibliography keys, and the program prints the references of the
  methods actually used at the end of each output.
- **Toolchain:** Sphinx + Read-the-Docs theme. The input reference is emitted from CP2K's own XML input
  description (`cp2k --xml`).
- **Good ideas:** completeness through generation; **"Lone keyword"** and **"Mentions"** fields; per-keyword
  references; links to source.

### 1.7 Gaussian 16 (https://gaussian.com/keywords/, optional)

- One web page per route keyword. Pages are tabbed (**Description / Options**; many keywords also have
  **Availability / Related Keywords / Examples**). Options are grouped by purpose (e.g. SCF: Algorithm
  selection, Integral storage, Convergence and cutoffs, Symmetry, Restart). Each option is a subheading with
  prose, defaults stated inline ("NoDamp is the default"), and synonyms and negated forms listed (`NoDIIS`).
  Citations are short keys (`Pulay82`) linked to a references glossary. Each page carries a stamp
  "Last updated on ... [G16 Rev. C.01]". There are separate pages for tutorials and FAQs.
- **Good ideas:** keyword-centric pages with an **Availability** tab (which methods/jobs support the option);
  synonyms/negations; a per-page revision stamp.

---

## 2. Comparison table

| Aspect | ORCA 6.1 | GAMESS(US) | TURBOMOLE 8 | Psi4 | NWChem | CP2K | Gaussian |
|---|---|---|---|---|---|---|---|
| Input style | `!` simple keywords + `%block ... end` | `$GROUP key=val $END` (closest to Priroda) | `$keyword` data groups, `$end` | Python (Psithon) `set` options | directive blocks `... end` | nested `&SECTION ... &END` | route line `#P key=(opt)` |
| Top-level organization | Quickstart + 9 domain chapters; separate Tutorials site | 6 files: intro / input / examples / further info / programmer / hardware | install, run, define, chapters per method, keyword chapter, samples | user manual (tutorial, methods, appendices) + programmer manual | getting started, directives, chapters per method, examples, FAQ, bugs | hand-written methods + generated input tree | keyword pages + separate tutorials/FAQ |
| Keyword reference location | tables at end of each topic section | one big Section 2, per group, in input order | one chapter, per module | auto appendix by module/alpha, transcluded into method chapters | per directive inside method pages | generated tree per section | page per keyword |
| Per-keyword fields | Keyword / Value / Description (default in prose) | `= VALUE` lines, "(default)" tag, prose | `$kw` + type placeholder, prose default, example | **Type, Possible values, Default**, expert tier | syntax block w/ type + default, prose | **Type, Default, Aliases, Lone kw, Usage, Valid values, Refs, Mentions, source link** | options + prose default, synonyms |
| Structured (machine-readable) source | no (hand tables) | no | no | **yes** (scraped C++ comments) | no | **yes** (generated from code) | no |
| Tutorials vs reference | separate site + Quickstart chapter | examples chapter + essays | method chapters + samples chapter + online examples | tutorial chapter + Minimal Input per method | Getting Started + Tutorials + Examples | Getting Started/Methods vs Input Reference | separate tutorials |
| Theory | short outline opening each section | essays in Section 4 | per method chapter | "Theory" subsection per method | brief overview per module | Methods pages | minimal |
| Troubleshooting / FAQ | per-section FAQ + "Solving common issues" tutorial | hints inside essays | scattered; forum | "Recommendations"; forum | **FAQ + Known Bugs** pages | how-tos; forum | FAQ pages |
| Citations | numeric → global bibliography; **program prints citations + .bibtex** | program ref in intro; ref lists per topic | references per chapter | `[Author:Year:Page]` → bibliography | numbered refs per page with DOI | bib keys per keyword; **program prints refs** | keys → glossary |
| Toolchain | Sphinx + Furo + MyST (inferred), PDF | plain ASCII + PDF + `gmshelp` | LaTeX legacy → custom static site (KaTeX), versioned | Sphinx/reST, MathJax, LaTeX PDF, scrapers | MkDocs Material, GitHub Markdown | Sphinx RTD, generated | proprietary web CMS |
| Versioning | per version URL | file date stamps | `/v8.0/`, `/v8.1/` selector | master/stable | single (GitHub) | per release | revision stamp per page |

---

## 3. Recommendations for the Priroda manual

Constraints taken from `research/00_local_files.md`. Input is NAMELIST-like `$group key=value ... $end`,
case-insensitive. Keyword names can be **abbreviated to any unique prefix**, arrays use indexed assignment
(`core(280)=2,1,0,0`, `val(5)=2.0,2.1`), some keywords take multiple values (`tolerance=1e-4,1e-2`), and some take
flag sets (`print=+charges+bonds`). **The same keyword name appears in different groups with different
meanings** (`steps` in `$optimize` vs `$d2edr2`), so keywords must always be namespaced by group. The legacy docs
(`input.txt`, `Dft.rtf`) are short, in two languages, and partly contradictory about defaults, so every entry
needs a *verified-against* field.

### 3.1 (a) Proposed chapter outline

Model: ORCA's Quickstart/how-to-use front matter + GAMESS's group-per-chapter reference in input order + Psi4's
per-method "Minimal input → keywords → recommendations" pattern + NWChem's Known Problems page.

**Part I: Getting started**
1. *About Priroda.* What it is, history (Laikov), capabilities summary, **capability matrix** (rows: energy,
   gradient, Hessian (analytic/numeric), optimization/TS/IRC/scan, NMR, TDDFT, thermo; columns: DFT, riDFT,
   riMP2, CCSD, CCSD(T), four-component `four=1`; marks for MPI-parallel and direct integrals), **how to cite**
   (program + methods + basis sets), license/distribution.
2. *Installation and running.* Binaries, MPI launch (`mpirun -np N p input output`), `$system` memory/disk/path
   (RAM disk, per-process paths, never NFS), environment, basis-set files, output files.
3. *Quickstart: your first calculations.* About five complete inputs with annotated output excerpts: water
   energy, optimization + frequencies, TS + IRC, RI-MP2/CCSD(T) single point, NMR shielding.
4. *How to use this manual.* Typographic conventions and **formal input grammar** (like NWChem's notation
   section and GAMESS's "Input Philosophy"): `$group ... $end`, case, unique-prefix abbreviation, lists,
   indexed arrays, `+flag` sets, comments, group order, repeated groups.

**Part II: Running typical calculations (task-oriented how-tos)**

5. Single-point energies (DFT / riDFT; choice of functional and basis; grids).
6. Geometry optimization (internal vs Cartesian, convergence, constraints `fix`/`val`, linear fragments).
7. Transition states, IRC, and relaxed scans (the Hessian requirement for `saddle=1`/`irc`, `follow`, `trust`).
8. Hessians, vibrational frequencies, and thermochemistry (analytic vs numerical `$d2edr2`, the split/parallel
   numerical Hessian recipe, `$thermo`, Molden visualization via `grep "freq>"`).
9. Correlated methods: RI-MP2, CCSD, CCSD(T) (memory and disk, frozen core, auxiliary basis sets).
10. Scalar-relativistic four-component calculations (`four=1`, nucleus models, basis requirements).
11. NMR shielding (`$nmr`, reference standards).
12. Excited states: TDDFT.
13. Properties and analysis (charges, bond orders, ESR, orbitals/Molden, dipole).
14. Parallel performance and resource tuning (MPI, memory, disk, direct integrals).

Each chapter follows one fixed template (Psi4-style): *Overview → Minimal input → Explanation of key options →
Advanced usage → Recommendations / pitfalls → FAQ for this task → Keyword summary (links into Part IV) →
References.*

**Part III: Methods and theory**

15. Density fitting (RI) in Coulomb/XC and in MP2. 16. Functionals implemented (table: name, type, components,
reference). 17. Basis sets and auxiliary sets shipped (table + references). 18. Integration grids (adaptive
accuracy). 19. Four-component scalar-relativistic Hamiltonian. 20. Optimization algorithms and coordinates.
21. NMR (GIAO or whatever Priroda uses; verify). Keep these short, ORCA-style: equations, references, and a
link back to the how-to chapter.

**Part IV: Input reference (one chapter per `$group`, in input-writing order)**

`$system`, `$control`, `$molecule`, `$basis`/basis files, `$guess`, `$scf`, `$dft`, `$grid`, `$integral`,
`$atoms`, `$optimize`, `$d2edr2`, `$thermo`, `$nmr`, plus whatever else is verified. The part opens with a
GAMESS-style master table (*group | purpose | required/when relevant*). Each group chapter opens with the
group's purpose, a **relevance line** ("read when `task=optimize|irc|scan`"), the 3–5 most important keywords,
and then one entry per keyword (template below). An alphabetical keyword index (Psi4 "by alpha") is generated
automatically.

**Part V: Troubleshooting**

22. *Solving common problems:* SCF divergence (NR → `procedure=bfgs`, level shift, guess mixing), optimization
not converging (and why raising `steps` rarely helps), RI-MP2 memory and parallel hangs, the `$scf` parser
quirk, disk/RAM-disk issues. Each item is written as symptom → cause → fix, using material from forum threads
(e.g. `research/05_chemport_112860.md`).
23. *Known bugs and version differences* (NWChem-style): obsolete keyword names from older Priroda versions
mapped to current ones.
24. *FAQ.*

**Appendices**

A. Complete example inputs (ideally also the regression tests, with expected energies: GAMESS/Psi4 idea).
B. Output file guide (what `freq>`, `mos>`, `num>` lines mean; Molden export).
C. Physical constants and units. D. Glossary. E. Change log / version history. F. Bibliography. G. Index.

### 3.2 (b) Keyword-entry template for `$group` keywords

Use a fixed field set that merges Psi4 (Type/Default/Possible values), CP2K (Usage, Lone keyword, References,
Mentions), GAMESS (default flagged per value, dependency rules), and TURBOMOLE (status tags). It needs four
fields specific to Priroda: **Group**, **Minimum abbreviation**, **Array/multi-value form**, and **Verified
against**.

**Source of truth: one structured record per keyword** (YAML, one file per group), rendered into the reference
pages and the alphabetical index. The same file could later feed a `priroda-help optimize steps` terminal
command (the GAMESS `gmshelp` idea) or an input checker:

```yaml
# keywords/optimize.yaml
group: optimize
summary:
  en: Geometry optimization, saddle-point search, IRC and scan control.
  ru: Управление оптимизацией геометрии, поиском седловых точек, IRC и сканированием.
relevant_when: "task = optimize | irc | scan"
keywords:
  - name: steps
    type: integer            # integer | real | logical(0/1) | string | enum | list | indexed-array | flags
    default: 50
    range: ">= 1"
    units: null
    multi_value: false       # true for e.g. tolerance=%f,%f
    abbreviation: "st"       # shortest unique prefix within the group (verify against parser)
    applies_to: [optimize, irc, scan]
    level: basic             # basic | advanced | expert | developer
    status: current          # current | deprecated | undocumented | removed
    since: null
    aliases: []
    description:
      en: Maximum number of optimization cycles.
      ru: Максимальное число шагов оптимизации.
    notes:
      en: Non-convergence within 50 steps usually signals a problem (bad starting geometry,
          wrong coordinates, too coarse grid); raising `steps` rarely helps.
      ru: Если оптимизация не сошлась за 50 шагов, причина обычно в другом (плохая начальная
          геометрия, координаты, грубая сетка); увеличение `steps` редко помогает.
    example: |
      $optimize steps=100 tolerance=1e-5 $end
    see_also: [optimize.tolerance, optimize.trust, control.task]
    not_to_be_confused_with: [d2edr2.steps]
    references: []
    verified_against: "input.txt (newest); Dft.rtf agrees; program version TBD"
```

**Rendered entry** (what the reader sees, in MyST/Sphinx or any similar tool):

> #### `steps` (`$optimize`)
> | | |
> |---|---|
> | **Type** | integer |
> | **Default** | `50` |
> | **Allowed** | ≥ 1 |
> | **Abbreviation** | `st` (any unique prefix is accepted) |
> | **Relevant for** | `task=optimize`, `irc`, `scan` |
> | **Level** | basic |
>
> Maximum number of optimization cycles.
>
> **Note.** Non-convergence within 50 steps usually signals a problem; raising `steps` rarely helps.
> See [Troubleshooting → optimization](#).
>
> **Example:** `$optimize steps=100 tolerance=1e-5 $end`
>
> **See also:** `$optimize tolerance`, `$optimize trust`, `$control task`. Not to be confused with `$d2edr2 steps`.

Conventions for special cases:
- **Enum keywords:** one row per value in a value table (*value | meaning*), with the default row marked
  **(default)** (GAMESS style, but a structured column instead of buried prose). If the default depends on other
  input (e.g. default functional for `theory=dft` vs `theory=ridft`), say so explicitly: "Default: `PBE`
  (`theory=dft`), `PBE1` (`theory=ridft`)", following GAMESS's per-runtype default tables.
- **Multi-value keywords** (`tolerance=%f,%f`): document each position ("1st: gradient, au; 2nd: displacement,
  au"), plus what happens when only some positions are given.
- **Indexed arrays** (`core(Z...)=`, `val(i)=`, `na(i)=`): give the index meaning and formula, and a worked
  example.
- **Flag sets** (`print=+charges+bonds`): a table of flags, CP2K "valid values" style.
- **Logical 0/1 switches:** state the "1 =" and "0 =" meanings and which one is the default (as `input.txt`
  already does).
- **Lone/positional forms** (`task=optimize+hessian`): use a CP2K-like "Usage" line for combined values.
- **Status tags** (TURBOMOLE idea): *deprecated (use X)*, *undocumented, behaviour verified on version Y*,
  *developer only*. Never silently document a keyword that has not been checked against the current binary.
- Anchor IDs are always `group.keyword` (e.g. `optimize.steps`), so cross-references are unambiguous.

### 3.3 (c) Recommended toolchain

**Recommendation: Sphinx + MyST-Markdown, Furo (or PyData/Book) theme, MathJax, `sphinxcontrib-bibtex`, LaTeX
PDF via XeLaTeX/LuaLaTeX, keyword pages generated from YAML, translations via `sphinx-intl` (gettext).** The
sources live in git, CI builds HTML + PDF for both languages, and output is published per program version.

Justification:
- **It is the de facto standard in the field.** ORCA (Sphinx + Furo + MyST), Psi4 (Sphinx/reST) and CP2K
  (Sphinx RTD) all use it, so readers already know the look and authors can copy proven patterns.
- **Markdown authoring (MyST) keeps the entry barrier low** (an NWChem/MkDocs-like experience) while keeping
  Sphinx's real cross-references (`{ref}`/custom roles), automatic index, numbered equations, admonitions, and
  `toctree` part/chapter structure.
- **A first-class PDF.** Russian users of a niche program often want a single printable/offline document.
  Sphinx's LaTeX builder with XeLaTeX handles Cyrillic properly (`latex_engine = 'xelatex'`, a font with
  Cyrillic such as PT Serif or DejaVu, babel/polyglossia `russian`). MkDocs PDF plugins are much weaker.
- **Citations:** `sphinxcontrib-bibtex` with one `refs.bib` gives a single bibliography (ORCA/Psi4 style) and
  lets the same BibTeX feed a "How to cite" page. If Priroda is ever changed to print citations at run time
  (ORCA/CP2K idea), the same `.bib` keys could be reused.
- **Keyword single source:** a ~100-line Python Sphinx extension (or a pre-build script writing `.md`) renders
  `keywords/*.yaml` into the Part IV pages, the alphabetical index, and "Keyword summary" tables transcluded
  into how-to chapters (Psi4's transclusion idea). A custom Sphinx domain or `object`-type directive
  (`{pri:keyword} optimize.steps`) gives index entries and a `{pri:kw}` cross-reference role. The YAML can also
  be dumped as plain text for a `gmshelp`-style terminal helper.
- **Bilingual Russian/English: two viable models.**
  1. *English master + gettext translation* (`sphinx-build -b gettext` → `sphinx-intl update -l ru` → `.po`
     files → `-D language=ru`). This is the standard Sphinx i18n path. Tools such as Weblate show which strings
     are out of date. It is best if English is the canonical text.
  2. *Russian-first*, if the main audience and authors are Russian (likely, given `Dft.rtf`): use Russian as the
     source language and English as the translation through the same gettext mechanism (Sphinx supports any
     source language).

  In both models the **keyword YAML carries `en:`/`ru:` fields directly**. The reference data, defaults and
  examples are then shared and cannot drift between languages; only descriptions are translated. Theory chapters
  with equations translate cheaply because the math is shared. Build two sites (`/en/`, `/ru/`) with a language
  switcher and two PDFs. Avoid maintaining two independent source trees: the defaults will diverge, which is
  already visible between `input.txt` and `Dft.rtf`.
- **Alternatives considered:**
  - *MkDocs Material* (NWChem) is the nicest default UX and has the `mkdocs-static-i18n` plugin. PDF output,
    cross-referencing, numbered equations and indices are weaker, so it is acceptable for a web-only manual.
  - *Plain LaTeX* (old TURBOMOLE) gives a great PDF, but poor web output and hard i18n. TURBOMOLE's mechanical
    LaTeX-to-web conversion still shows artifacts.
  - *Plain text* (GAMESS) is greppable and terminal-friendly, but has no links, math or structure. Keep its
    virtue by generating a plain-text keyword dump from the YAML.
  - *Quarto / Jupyter Book* (Sphinx-based) are reasonable if executable examples are wanted, but probably
    unnecessary.

### 3.4 Other ideas worth adopting (short list)

1. ORCA: a **separate tutorials/quickstart track** and a "How to use this manual" page. Tutorials link into the
   reference and never duplicate keyword lists.
2. GAMESS: **group-per-chapter reference in input order**, a "relevant if / required if" line per group, and a
   "most important keywords" box for long groups such as `$control` and `$optimize`.
3. GAMESS/Psi4: **examples = regression tests with expected results** embedded, so they double as installation
   checks.
4. Psi4: **basic / advanced / expert** tiers, a "Minimal input" + "Recommendations" pair per method chapter, and
   an **output-quantity glossary** (what each tagged output line such as `freq>` or `num>` means and how to grep
   it).
5. CP2K: **"Mentions" back-links** from each keyword to the how-tos that use it, plus per-keyword references.
6. NWChem: a formal syntax-notation section, **Known Bugs** and **FAQ** pages, and an "edit this page" link.
7. TURBOMOLE/ORCA: **versioned manual URLs** and a PDF per version. Every keyword entry records the version on
   which it was verified.
8. GAMESS/ORCA/Gaussian: a **capability matrix** and a "How to cite" page (program, then methods, then basis
   sets).

---

## Sources

- ORCA docs hub: https://www.faccts.de/docs/orca/ ; manual 6.1: https://www.faccts.de/docs/orca/6.1/manual/ ;
  "How to use this manual": https://www.faccts.de/docs/orca/6.1/manual/contents/preface/howtousethismanual.html ;
  "How to cite": https://www.faccts.de/docs/orca/6.1/manual/contents/preface/howtocite.html ;
  Geometry optimizations (keyword tables, FAQ): https://www.faccts.de/docs/orca/6.1/manual/contents/structurereactivity/optimizations.html ;
  Tutorials 6.1: https://www.faccts.de/docs/orca/6.1/tutorials/ ; manual 6.0: https://www.faccts.de/docs/orca/6.0/manual/
- GAMESS documentation index: https://www.msg.chem.iastate.edu/gamess/documentation.html ;
  https://www.msg.chem.iastate.edu/gamess/GAMESS_Manual/docs-intro.txt , docs-input.txt , docs-tests.txt ,
  docs-references.txt , docs-prog.txt (downloaded and read directly)
- TURBOMOLE 8.0 manual: https://manual.turbomole.org/v8.0/ ; keyword chapter:
  https://manual.turbomole.org/v8.0/keywords-in-the-control-file/introduction/ ; format:
  https://manual.turbomole.org/v8.0/keywords-in-the-control-file/format-of-keywords-and-comments/ ; dscf/ridft
  keywords: https://manual.turbomole.org/v8.0/keywords-in-the-control-file/format-of-keywords-and-comments/keywords-for-modules-dscf-and-ridft/ ;
  legacy latex2html: https://extras.csc.fi/chem/progs/turbomole/DOC/DOC_HTML/DOK.html
- Psi4 manual: https://psicode.org/psi4manual/master/index.html ; methods: https://psicode.org/psi4manual/master/methods.html ;
  SCF options: https://psicode.org/psi4manual/master/autodir_options_c/module__scf.html ; appendices:
  https://psicode.org/psi4manual/master/appendices.html ; building the docs: https://psicode.org/psi4manual/master/documentation.html ;
  SCF chapter: https://psicode.org/psi4manual/master/scf.html
- NWChem: https://nwchemgit.github.io/ ; Getting Started: https://nwchemgit.github.io/Getting-Started.html ;
  DFT: https://nwchemgit.github.io/Density-Functional-Theory-for-Molecules.html
- CP2K: https://manual.cp2k.org/trunk/index.html ; SCF section: https://manual.cp2k.org/trunk/CP2K_INPUT/FORCE_EVAL/DFT/SCF.html
- Gaussian SCF keyword: https://gaussian.com/scf/
