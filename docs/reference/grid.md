<!-- Generated from keywords/grid.yaml by docs/_ext/priroda_keywords.py. Do not edit. -->


(group.grid)=
# `$grid`

```{index} single: $grid
```

Adaptive integration grid for DFT.

(grid.accuracy)=
## `accuracy`

```{index} single: accuracy ($grid)
```

**Type:** list\
**Default:** `1e-8,1e-5`\
**Status:** current · verified on 25 (2025.02.28)\
**Sources:** input.txt; 01 §4.4 (output echo); Dft.rtf; 08 t01, t04

Default: `1e-8` for the final grid and `1e-5` for the coarse grid used in the first SCF iterations, as echoed by v13, v15
and v25 (`grid: accuracy=1.0e-08,1.0e-05`). `Dft.rtf` gives `1e-7` (older version).


Target accuracy of the exchange–correlation energy per atom for the adaptively generated grid (DFT
methods). The default, 1e-8, is a fine grid. Use 1e-7 to speed up geometry optimizations with
`tolerance<=1e-4`, and 1e-9 for very accurate calculations. The grid grows during the SCF; the output
reports each size on a line such as `grid:    34000   53` (number of points) in the SCF table.

```{note}
`Dft.rtf` suggests 1e-6 for rough optimizations (`tol=1e-3`) and 1e-8 for floppy molecules optimized to
`tol=1e-5`. It says that asking for more than 1e-8 "makes no deep sense", because the integration formulas
cannot reach unlimited accuracy. This conflicts with `input.txt`'s 1e-9 for very accurate work.
```

**See also:** {ref}`tolerance ($optimize) <optimize.tolerance>`
