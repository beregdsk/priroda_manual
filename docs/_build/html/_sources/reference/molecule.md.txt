<!-- Generated from keywords/molecule.yaml by docs/_ext/priroda_keywords.py. Do not edit. -->


(group.molecule)=
# `$molecule`

```{index} single: $molecule
```

Charge, multiplicity, geometry (Cartesian and/or Z-matrix) and per-atom basis sets.

Unlike the other groups, `$molecule` holds **ordered data**. It starts with `charge=` and `mult=`, then one of the
keywords `cartesian` or `z-matrix`, followed by one line per atom.

Cartesian lines: `Z x y z`. **Z is the atomic number written as an integer**: `8`, not `8.0` and not `O`. The
atom lines are read as a stream of numbers, so a value such as `8.0` shifts everything after it. In version 25
this gives **no error**: the run continues with a wrong molecule (extra atoms with Z=0) and a meaningless
energy. Check the `formula:` and atom-count lines at the top of the output. The coordinates are in Å unless
`unit=b` is given.

Z-matrix lines, `Z j r k a l b`, can combine distances, angles and torsions in four ways:

| Form | Meaning |
|---|---|
| `q_i j r_ij  k a_ijk  l b_ijkl` | distance, angle, torsion |
| `q_i j r_ij  k a_ijk -l a_ijl` | distance and two angles |
| `q_i j r_ij -k r_ik   l b_ijkl` | two distances and torsion |
| `q_i j r_ij -k r_ik  -l r_il` | three distances |

Distances are in Å, and angles and torsions are in degrees. In a pure Z-matrix the first atom gives only its
atomic number, the second only a distance, and the third two internal coordinates. The two formats can be mixed:
put the Cartesian atoms first, then the remaining atoms as a Z-matrix.

The program does not use or impose point-group symmetry unless the newer `sym=` option is given. Dummy atoms
are not supported, so counterpoise (BSSE) calculations cannot be done; NICS probe points go in `$nmr points=`
instead. Some tasks (`transit`, `saddle`, `path`, `uniq`) read **several** `$molecule` blocks from one input.
Text after `$end`, such as the `Energy = …` lines that helper scripts append, is ignored. The line
`molecule input: ''` near the top of every output is normal and not an error.

(molecule.charge)=
## `charge`

```{index} single: charge ($molecule)
```

**Type:** integer\
**Default:** `0`\
**Status:** current · not verified\
**Sources:** input.txt; Dft.rtf (default)

Molecular charge.

(molecule.mult)=
## `mult`

```{index} single: mult ($molecule)
```

**Type:** integer\
**Default:** `1`\
**Status:** current · verified on 25 (2025.02.28)\
**Sources:** input.txt; Dft.rtf (default); 08 t10

Spin multiplicity, 2S+1.

(molecule.mass)=
## `mass`

```{index} single: mass ($molecule)
```

**Type:** real\
**Default:** *none stated*\
**Units:** amu\
**Status:** current · not verified\
**Sources:** input.txt

Optional atomic mass written after an atom's coordinates, for isotopes.

(molecule.set)=
## `set`

```{index} single: set ($molecule)
```

**Type:** string\
**Default:** *none stated*\
**Status:** current · not verified\
**Sources:** input.txt; 03 §5 (default set); 01 §4.11; 06 §1

Default: the set named by `default=` in the basis-file header (`L1` in `basis.in`).

Basis set for the atoms that follow. The name must match one in the basis-set file. It can appear several
times in the group. The orbital basis is paired with its own auxiliary (fitting) basis, so you cannot
combine arbitrary orbital and auxiliary sets.

**Example:**

```text
$molecule
 z-matrix
 set=B2
   8
 set=B1
   1    1    0.96252725
   1    1    0.96252725    2    102.943872
$end
```

**See also:** {ref}`basis ($control) <control.basis>`

(molecule.unit)=
## `unit`

```{index} single: unit ($molecule)
```

**Type:** string\
**Default:** *none stated*\
**Status:** undocumented · not verified\
**Sources:** 01 §4.7

Length unit of the coordinates. The default unit is Å.

```{tabularcolumns} \Y{0.3}\Y{0.7}
```

| Value | Meaning |
|---|---|
| `b` | Coordinates in bohr. |

(molecule.sym)=
## `sym`

```{index} single: sym ($molecule)
```

**Type:** list\
**Default:** *none stated*\
**Status:** undocumented · verified on 25 (2025.02.28)\
**Sources:** 01 §4.7; 04 #481; 08 t15; 08 t30a

Used as `sym=1,0.01` in the official 2023–2025 example inputs, apparently to enable symmetry with tolerance 0.01.
Newer versions report the detected point group (`symmetry: D6h`). In version 25, `sym=1,0.01` on a slightly
distorted NH3 printed `symmetry: C3v    6, unique:    2` and echoed the geometry symmetrized. On its own it
does not keep the symmetry during an optimization; add `$optimize sym=1` for that.

**See also:** {ref}`sym ($optimize) <optimize.sym>`
