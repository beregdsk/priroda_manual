<!-- Generated from keywords/molecule.yaml by docs/_ext/priroda_keywords.py. Do not edit. -->


(group.molecule)=
# `$molecule`

```{index} single: $molecule
```

Charge, multiplicity, geometry (Cartesian and/or Z-matrix) and per-atom basis sets.

Unlike the other groups, `$molecule` holds **ordered data**. It starts with `charge=` and `mult=`, then one of the
keywords `cartesian` or `z-matrix`, followed by one line per atom.

Cartesian lines: `Z x y z`. **Z is the atomic number written as an integer**: `8`, not `8.0` and not `O`. A value
such as `25.0` breaks parsing with `molecule input: ''`. The coordinates are in Å unless `unit=b` is given.

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
Text after `$end`, such as the `Energy = …` lines that helper scripts append, is ignored.

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
**Status:** current · not verified\
**Sources:** input.txt; Dft.rtf (default)

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
**Status:** undocumented · not verified\
**Sources:** 01 §4.7; 04 #481

Used as `sym=1,0.01` in the author's 2023–2025 inputs, apparently to enable symmetry with tolerance 0.01.
Newer versions report the detected point group (`symmetry: D6h`).

**See also:** {ref}`sym ($optimize) <optimize.sym>`
