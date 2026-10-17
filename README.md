# Priroda Unofficial Manual

A user manual for **Priroda**, the quantum-chemistry program by Dimitri Laikov: DFT with density fitting, hybrid
RI-DFT, RI-MP2 and coupled-cluster methods, TDDFT, scalar-relativistic calculations, NMR, the semiempirical QM model,
optimization, transition states, IRC and scans, Hessians and thermochemistry.

Priroda has no complete official manual. This one is **unofficial**: it was not written or reviewed by the developer.
It is compiled from the program's own files, the short keyword list that ships with it, user pages and forum threads,
and test runs on Priroda 25 (2025.02.28). The program itself is not part of this repository; it can be downloaded
from the official site, <https://rad.chem.msu.ru/~laikov/p_w/>.

The manual is in English and is a work in progress. Each keyword entry says which sources it rests on and whether it
has been checked against a running binary.

## Contents of the manual

- **Part I. Introduction**: about Priroda, installing and running it, getting started (first calculations and how to
  read the output), input syntax.
- **Part II. Input reference**: every known keyword, group by group, generated from `keywords/*.yaml`.
- **Part III. Troubleshooting**: common problems, by symptom.
- **Appendix**: the sources.

## Building

The manual is written in MyST Markdown and built with Sphinx.

```bash
python3 -m venv .venv && .venv/bin/pip install -r requirements.txt   # once
make html    # docs/_build/html/index.html
make pdf     # docs/_build/latex/priroda-manual.pdf (needs pdflatex and latexmk)
make keywords  # only validate keywords/*.yaml and regenerate docs/reference/
```

`make html` treats every warning as an error.

## Repository layout

| Path | What it holds |
|---|---|
| `docs/` | Manual source: `index.md`, the chapters in `start/` and `troubleshooting/`, `sources.md`, and `conf.py`. |
| `docs/reference/` | Input reference pages, **generated** from `keywords/` on every build. Do not edit them. |
| `docs/_ext/priroda_keywords.py` | Sphinx extension that validates the keyword YAML and writes the reference pages. Its docstring is the YAML schema. |
| `keywords/` | One YAML file per input group (`$control`, `$scf`, `$optimize`, …), one record per keyword. |
| `research/` | Notes extracted from each source, numbered `00`–`08`; `08` holds the test-run results. |
| `priroda_man/` | The original documentation files as received (`input.txt`, `Dft.rtf`, `Dft_ansi.txt`). Not edited. |
| `tests/` | Small Priroda inputs that check open questions, a script to run them, the outputs, and a results table. |
| `PLAN.md` | Outline, decisions, known conflicts between sources, and work order. |
| `CLAUDE.md` | Writing and sourcing conventions for contributors. |

## Running the tests

With a Priroda executable and the basis file from the official site:

```bash
cd tests
PRIRODA=/path/to/p BASIS=/abs/path/to/basis.in ./run.sh            # all tests
PRIRODA=/path/to/p BASIS=/abs/path/to/basis.in ./run.sh t22 t24    # selected tests
```

Outputs go to `tests/runs/<date>/`. `tests/README.md` lists what each test checks and records the results; the
findings are then written into `research/08_test_runs_v25.md`, the keyword YAML and the chapters.

## Contributing

Read `PLAN.md` and `CLAUDE.md` first. In short:

- Edit `keywords/*.yaml`, never the generated `docs/reference/*.md`.
- After each factual claim in the prose, name its source in an HTML comment (`<!-- src: 04 #324 -->`) and mark
  anything not yet checked on a running binary with `<!-- verify -->`.
- When sources disagree, program output wins over the official files, which win over `input.txt`, the older
  documentation and forum posts.
- State uncertain behaviour openly in a note or warning; do not guess.
