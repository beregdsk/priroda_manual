<!-- Generated from keywords/molecule.yaml by docs/_ext/priroda_keywords.py. Do not edit. -->


(group.molecule)=
# `$molecule`

```{index} single: $molecule
```

Charge, multiplicity, geometry (Cartesian and/or Z-matrix) and per-atom basis sets.

Unlike the other groups, `$molecule` holds **ordered data**. It starts with the optional `charge=` and `mult=`
(defaults 0 and 1), then one of the keywords `cartesian` or `z-matrix`, followed by one line per atom.

Cartesian lines: `Z x y z`. **Z is the atomic number written as an integer**: `8`, not `8.0` and not `O`. The
atom lines are read as a stream of numbers, so a value such as `8.0` shifts everything after it. In version 25
this gives **no error**: the run continues with a wrong molecule (extra atoms with Z=0) and a meaningless
energy. Check the `formula:` and atom-count lines at the top of the output. The coordinates are in Å unless
`unit=b` is given.

Z-matrix lines give the atomic number `Z_i` of atom i, then up to three reference atoms j, k, l, each followed
by an internal coordinate. They can combine distances, angles and torsions in four ways:

| Form | Meaning |
|---|---|
| `Z_i j r_ij  k a_ijk  l b_ijkl` | distance, angle, torsion |
| `Z_i j r_ij  k a_ijk -l a_ijl` | distance and two angles |
| `Z_i j r_ij -k r_ik   l b_ijkl` | two distances and torsion |
| `Z_i j r_ij -k r_ik  -l r_il` | three distances |

Distances are in Å (bohr with `unit=b`), and angles and torsions are in degrees. In a pure Z-matrix the first atom gives only its
atomic number, the second only a distance, and the third two internal coordinates. The two formats can be mixed:
put the Cartesian atoms first, then the remaining atoms as a Z-matrix.

The program does not use or impose point-group symmetry unless the newer `sym=` option is given. Users report
that ghost atoms (basis functions without a nuclear charge), which counterpoise (BSSE) corrections need, are not
available. In version 25, atoms with Z=0 are accepted but carry no basis functions, so they are not ghost atoms.
NICS probe points go in `$nmr points=` instead. Some tasks (`transit`, `saddle`, `path`, `uniq`) read **several** `$molecule` blocks from one input.
Text after `$end`, such as the `Energy = …` lines that helper scripts append, is ignored. The line
`molecule input: ''` near the top of every output is normal and not an error.

(molecule.charge)=
{.kw}
## `charge`

```{index} single: charge ($molecule)
```

**Type:** integer\
**Default:** `0`\
**Status:** current · verified on 25 (2025.02.28)\
**Sources:** version 25 test runs, `input.txt`, `Dft.rtf`

Molecular charge.

(molecule.mult)=
{.kw}
## `mult`

```{index} single: mult ($molecule)
```

**Type:** integer\
**Default:** `1`\
**Status:** current · verified on 25 (2025.02.28)\
**Sources:** version 25 test runs, `input.txt`, `Dft.rtf`

Spin multiplicity, 2S+1.

(molecule.mass)=
{.kw}
## `mass`

```{index} single: mass ($molecule)
```

**Type:** real\
**Default:** *none stated*\
**Units:** amu\
**Status:** current · not verified\
**Sources:** `input.txt`

Optional atomic mass for isotopes, written as `mass=` after an atom's coordinates on the same atom line, in
both Cartesian and Z-matrix input. Not tested in version 25.

**Example:**

```text
1  0.0  0.0  0.96  mass=2.014
```

(molecule.set)=
{.kw}
## `set`

```{index} single: set ($molecule)
```

**Type:** string\
**Default:** *none stated*\
**Status:** current · verified on 25 (2025.02.28)\
**Sources:** version 25 test runs, official site files, `input.txt`, KNC wiki, qchem.ru forum

Basis set for the atoms that follow. The name must match one in the basis-set file. It can appear several
times in the group. The orbital basis is paired with its own auxiliary (fitting) basis, so you cannot
combine arbitrary orbital and auxiliary sets.

**About the default:** the set named by `default=` in the basis-file header (`L1` in `basis.in`).

**Example:**

```priroda
$molecule
 z-matrix
 set=L2
   8
 set=L1
   1    1    0.96252725
   1    1    0.96252725    2    102.943872
$end
```

**See also:** {ref}`basis ($control) <control.basis>`

(molecule.unit)=
{.kw}
## `unit`

```{index} single: unit ($molecule)
```

**Type:** string\
**Default:** *none stated*\
**Status:** undocumented · verified on 25 (2025.02.28)\
**Sources:** version 25 test runs, official site files

Length unit of the coordinates. The default unit is Å. In version 25, water given in bohr with `unit=b` gave the same geometry and energy as in Å.

```{tabularcolumns} \Y{0.3}\Y{0.7}
```

| Value | Meaning |
|---|---|
| `b` | Coordinates in bohr. |

(molecule.sym)=
{.kw}
## `sym`

```{index} single: sym ($molecule)
```

**Type:** list\
**Default:** *none stated*\
**Status:** undocumented · verified on 25 (2025.02.28)\
**Sources:** version 25 test runs, official site files, chemport.ru forum

Used as `sym=1,0.01` in the official 2023–2025 example inputs, apparently to enable symmetry with tolerance 0.01.
Newer versions report the detected point group (`symmetry: D6h`). In version 25, `sym=1,0.01` on a slightly
distorted NH3 printed `symmetry: C3v    6, unique:    2` and echoed the geometry symmetrized. On its own it
does not keep the symmetry during an optimization; add `$optimize sym=1` for that.

**See also:** {ref}`symmetry ($optimize) <optimize.symmetry>`
