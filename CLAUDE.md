# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A documentation project: writing a user manual for **Priroda**, a closed-source quantum-chemistry program by Dimitri Laikov (DFT with density fitting, RI-MP2, CCSD(T), scalar-relativistic `four=1`, NMR, TDDFT, a QM semiempirical model, optimization/TS/IRC/scan, hessians/thermochemistry; MPI-parallel). Priroda has no real official manual. Knowledge is scattered across a short keyword list, user-written pages and forum threads. The manual is **English only for now** (decisions in `PLAN.md` §0).

## Commands

```bash
python3 -m venv .venv && .venv/bin/pip install -r requirements.txt   # one-time setup
make keywords   # validate keywords/*.yaml and regenerate docs/reference/ (fast, no Sphinx)
make html       # docs/_build/html; -W makes any warning fail the build
make pdf        # docs/_build/latex/priroda-manual.pdf (pdflatex; see the font note in docs/conf.py)
make clean
```

## Keyword pipeline

The input reference (Part III in the built manual) is not hand-written. `keywords/<group>.yaml` holds one record per keyword (schema in the docstring of `docs/_ext/priroda_keywords.py`). That Sphinx extension runs on `builder-inited` and writes `docs/reference/<group>.md` and `docs/reference/index.md`, so **edit the YAML, never the generated `.md`**.

The extension validates on every build:
- required fields;
- `type` and `status` enums;
- at least one entry in `sources`;
- no duplicate names;
- every `see_also` anchor exists;
- every `sources` prefix (`08`, `input.txt`, …) is in `SOURCE_NAMES`. The page shows only those reader-facing names,
  in evidence order; note sections and post numbers stay in the YAML.

Anchors are `group.keyword` (e.g. `optimize.steps`). Use them from chapter prose with ``{ref}`text <optimize.steps>` ``. Group order in the reference comes from each file's `order:` field (input-writing order, in steps of 10).

Record conventions:
- `default: null` means no source states a default. Do not fill it in from guesses.
- `verified_against` stays `null` until a keyword has been checked against a running Priroda binary. The user will run the program later.
- `status: undocumented` marks keywords known only from forums, examples or corrupted annotations.

## Writing manual prose (`docs/**/*.md`, MyST Markdown, English)

- **Provenance stays in the source, not the page.** After each non-obvious factual claim, add an HTML comment naming
  its research source, e.g. `<!-- src: 04 #324; input.txt -->`. Mark anything a test run should confirm with
  `<!-- verify -->`. Readers never see these comments; the author uses them for D4 verification passes.
  **Never put a `>` inside a comment** (e.g. `eng>`, `MOL>`): MyST ends an inline comment there, and the rest
  leaks onto the page. Write `eng-prefixed lines` instead.
- The manual is unofficial. Never call Laikov "the author" in prose: write "the developer", "Laikov", "the official
  site" or name the file (`input.txt`). Don't add placeholder pages or link to chapters that don't exist yet.
- Uncertain behaviour gets an explicit `:::{note}` or `:::{warning}` in the text ("reported by users, not confirmed"),
  never silent hedging and never invented detail.
- Link keywords as ``{ref}`steps <optimize.steps>` ``, and groups as ``{ref}`$optimize <group.optimize>` ``. Don't
  restate the reference tables in prose; give the task-level advice and link.
- Input examples go in ```` ```priroda ```` blocks (the highlighter in `docs/_ext/priroda_lexer.py`; text outside
  groups shows as a comment) and must be syntactically valid Priroda input with integer atomic numbers. Program
  output goes in ```` ```text ````, shell commands in ```` ```bash ````. Mark untested examples with `<!-- verify -->`.
- Diagrams use the `{graphviz}` directive (SVG in HTML, PDF in LaTeX). Theme colours and fonts are in `docs/conf.py`
  and `docs/_static/priroda.css`.
- `make html` must stay warning-free (`-W`).

## Layout

- `priroda_man/`: the original files as received, provided by Alexandra Freidzon. **Do not edit.** None of them is
  official: never describe them as the developer's or as shipping with the program.
  - `input.txt`: English "Input Summary", the most complete keyword list, but unofficial. Its Russian annotations (lines 60–61, 75, 127–128, 419–421) were corrupted to `?` and cannot be recovered from this file.
  - `Dft.rtf`: Russian, cp1251.
  - `Dft_ansi.txt`: Russian, cp1251 + CRLF; describes the predecessor program with obsolete group names.
- `research/`: extracted notes, one per source, numbered `00`–`09`. `08` records the test runs on Priroda 25 (program output, the strongest evidence; cite as `08 tNN`). `09` lists every group, keyword, task and theory name found in the v25 executable (`p4_d`); it settles which names exist, not what they do. `00_*_utf8.txt` are UTF-8 conversions of the cp1251 originals. `07` is the survey of other QC manuals (ORCA, GAMESS, TURBOMOLE, Psi4, NWChem, CP2K, Gaussian) with the recommended outline, keyword-entry template and toolchain.
- `PLAN.md`: manual outline, settled decisions, table of known conflicts, and work order with progress. Read it before writing manual content.
- `tests/`: minimal verification inputs for the open questions (`PLAN.md` §3a), `run.sh`, and a results table in
  `tests/README.md`.
- `keywords/`: the YAML keyword source. `docs/`: the Sphinx source (`conf.py`, `index.md`, `_ext/`, generated `reference/`).

## Working with the sources

- **Sources conflict and some are obsolete.** Before stating a default or keyword as fact, check `PLAN.md` §3 and `research/01_official_site.md` §10. The evidence order is: program output (`08` test runs, official example outputs) / official site files > `input.txt` > the v5 wiki docs (`06`) > `Dft.rtf` > forum posts > `Dft_ansi.txt` (predecessor).
- The research notes tag their own guesses as *(inferred)* or "my reconstruction", and tag second-hand Laikov quotes as "relayed". Keep those distinctions when moving material into the manual. Do not document a keyword as current without a source.
- Forum notes cite posts as `#N` (chemport t=28803 has 518 posts and is by far the largest source, at 287 KB). Grep them rather than reading them whole.
- Keywords are namespaced by group (`optimize.steps` ≠ `d2edr2.steps`), and Priroda accepts any unique prefix (`tol=` = `tolerance=`, `cart=` = `cartesian=`), so search the sources for prefixes as well as full names.
- Reading the cp1251 originals: `iconv -f cp1251 -t utf-8`. Converting RTF: `soffice --headless --convert-to "txt:Text (encoded):UTF8"`.

## Source URLs (already harvested into `research/`)

- Official binaries and files: https://rad.chem.msu.ru/~laikov/p_w/ (a file index only, with no prose docs)
- limor1 user page and scripts: http://limor1.nioch.nsc.ru/priroda.html (about 25 further chemport thread links listed in `02` are not yet harvested)
- Forums: qchem.ru (Wayback archive), chemport.ru t=28803 and t=112860
- KNC wiki beginner FAQ and v5 keyword page (Wayback archive; who wrote them is not known, so never attribute them to the developer or to anyone else); PDF mirror of the KNC docs: https://monitor.hpc.umanitoba.ca/doc/Priroda_Documentation_from_KNCWiki.pdf
