# Priroda Unofficial Manual

Priroda is a fast quantum-chemistry program for molecules by Dimitri Laikov: density-fitted DFT, hybrid RI-DFT,
RI-MP2 and coupled-cluster methods, TDDFT, scalar-relativistic calculations, NMR and a semiempirical model. It has
no official manual; this one collects what is known about its input, output and quirks, and checks it against test
runs of version 25.

```{important}
This manual is not an official Priroda document. It was not written or reviewed by the developer. It is compiled
from the files on the official site, unofficial keyword lists and wiki pages, test runs, and user reports from
forums and user pages; {ref}`sources` lists them all. When this manual and the program disagree, the program is right.
```

```{rubric} Where to start
```

{.paths}
- [New to Priroda]{.path-title} Read {doc}`start/about` to see whether the program fits your project, then work
  through {doc}`start/getting-started`: a single-point energy, an optimization with a frequency check, and how to
  read the output.
- [Looking up a keyword]{.path-title} The {doc}`input reference <reference/index>` describes every known keyword,
  group by group. The {ref}`index <genindex>` lists them alphabetically.
- [A run failed]{.path-title} {doc}`troubleshooting/common-problems` is arranged by symptom, with the error messages
  as the program prints them.

```{only} html
The whole manual is also available as a [PDF](https://beregdsk.github.io/priroda_manual/priroda-manual.pdf).
```

```{raw} latex
\part{Introduction}
```

```{toctree}
:caption: Part I. Introduction
:maxdepth: 2
:hidden:

start/about
start/getting-started
start/input-syntax
start/running
start/parallel
```

```{raw} latex
\part{Calculations}
```

```{toctree}
:caption: Part II. Calculations
:maxdepth: 2
:hidden:

tasks/ts-irc-scan
```

```{raw} latex
\part{Input reference}
```

```{toctree}
:caption: Part III. Input reference
:maxdepth: 2
:hidden:

reference/index
```

```{raw} latex
\part{Troubleshooting}
```

```{toctree}
:caption: Part IV. Troubleshooting
:maxdepth: 2
:hidden:

troubleshooting/common-problems
```

```{raw} latex
\appendix
```

```{toctree}
:caption: Appendix
:maxdepth: 2
:hidden:

binary-keywords
sources
```
