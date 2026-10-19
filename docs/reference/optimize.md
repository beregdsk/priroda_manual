<!-- Generated from keywords/optimize.yaml by docs/_ext/priroda_keywords.py. Do not edit. -->


(group.optimize)=
# `$optimize`

```{index} single: $optimize
```

Geometry optimization, saddle-point search, IRC and relaxed scans.

**Relevant when:** `task = optimize | optimize+hessian | irc | scan | opt_n1`

(optimize.saddle)=
{.kw}
## `saddle`

```{index} single: saddle ($optimize)
```

**Type:** switch\
**Default:** `0`\
**Status:** current · verified on 25 (2025.02.28)\
**Sources:** version 25 test runs, `input.txt`, `Dft.rtf`, chemport.ru forum, qchem.ru forum

Type of stationary point sought.

```{tabularcolumns} \Y{0.3}\Y{0.7}
```

| Value | Meaning |
|---|---|
| `0` | Optimize to a minimum. (**default**) |
| `1` | Optimize to a saddle point. |

```{note}
A saddle-point search needs an accurate Hessian in the input: compute one with `task=hessian` and append its
`$Energy` block (the `eng>` lines). A usual route is scan → Hessian at the scan maximum → `saddle=1` →
`task=hessian` to confirm one imaginary frequency → IRC. In version 25 the output confirms the search with
`Saddle point search: follow = 1` and, when a Hessian was read from `$Energy`, `Lowest eigenvalues:` with one
negative value.
```

**See also:** {ref}`follow ($optimize) <optimize.follow>`, {ref}`H ($Energy) <Energy.H>`

(optimize.tolerance)=
{.kw}
## `tolerance`

```{index} single: tolerance ($optimize)
```

**Type:** list\
**Default:** `0.0001,0.01`\
**Units:** au\
**Status:** current · verified on 25 (2025.02.28)\
**Sources:** version 25 test runs, official site files, `input.txt`

Convergence tolerance on the gradient (first value) and on the displacement (second value).

**About the default:** if only the first value is given, the second is 100 times larger (the recommended setting).

**See also:** {ref}`accuracy ($grid) <grid.accuracy>`

(optimize.trust)=
{.kw}
## `trust`

```{index} single: trust ($optimize)
```

**Type:** list\
**Default:** `0.125,0.015625`\
**Status:** current · verified on 25 (2025.02.28)\
**Sources:** version 25 test runs, official site files, `input.txt`, `Dft.rtf`, chemport.ru forum

Trust radius (the largest allowed step), given as maximum, minimum and initial values.

**About the default:** echoed by version 25 as `Trust radius = 0.12500000 (max), 0.01562500 (min)` in internal coordinates, with
symmetry (`sym=1`) and with `cartesian=1`. v13 and v15 echoed 0.2 / 0.0125 in internal coordinates and
0.1 / 0.00625 with `cartesian=1`; v6 echoed 0.2 / 0.0125 in Cartesian coordinates. `Dft.rtf` gives 0.5
(older version). `input.txt` says that if only the maximum is given, the minimum is 1/16 of it and the initial
value 1/4. Version 25 uses 1/8 instead: `trust=0.2` alone was echoed as `0.20000000 (max), 0.02500000 (min)`.


(optimize.follow)=
{.kw}
## `follow`

```{index} single: follow ($optimize)
```

**Type:** integer\
**Default:** `1`\
**Status:** current · verified on 25 (2025.02.28)\
**Sources:** version 25 test runs, `input.txt`, `Dft.rtf`

Follow the n-th Hessian eigenvector in a saddle-point search.

**About the default:** `1` according to `Dft.rtf`; version 25 echoes `Saddle point search: follow = 1`.

**See also:** {ref}`saddle ($optimize) <optimize.saddle>`

(optimize.steps)=
{.kw}
## `steps`

```{index} single: steps ($optimize)
```

**Type:** integer\
**Default:** `128`\
**Status:** current · verified on 25 (2025.02.28)\
**Sources:** version 25 test runs, `input.txt`, `Dft.rtf`, qchem.ru forum

Maximum number of optimization cycles.

```{note}
Version 25 echoes `Maximum number of steps = 128` when `steps` is not given; older sources give 50. When the
limit is reached the program prints no message: the output just ends, and the last geometry appears only in
`mol>` lines, not `MOL>`. `Dft.rtf` warns that an optimization not converged after about 50 steps very likely
has something wrong with it, and that computing a Hessian first helps in many cases; so don't simply raise
`steps`. In v6, if both `steps` and `step` are
given, the value of `step` is used; give only one of them.
```

**See also:** {ref}`tolerance ($optimize) <optimize.tolerance>`, {ref}`steps ($d2edr2) <d2edr2.steps>`

(optimize.cartesian)=
{.kw}
## `cartesian`

```{index} single: cartesian ($optimize)
```

**Type:** switch\
**Default:** `0`\
**Status:** current · verified on 25 (2025.02.28)\
**Sources:** version 25 test runs, official site files, `input.txt`, chemport.ru forum

Coordinate system for the optimization. The output reports `Coordinates: internal` or `cartesian`.

```{tabularcolumns} \Y{0.3}\Y{0.7}
```

| Value | Meaning |
|---|---|
| `0` | Redundant internal coordinates. (**default**) |
| `1` | Cartesian coordinates (last resort). |

```{note}
`cartesian=1` is the fix when the program crashes with `process 0 got signal 6` after a `too few` message in
the internal-coordinate table. In version 25, bent CO2 and acetylene that became linear during the optimization
converged in internal coordinates without that crash (the number of internal coordinates dropped instead), and
also with `cartesian=1`.
```

(optimize.back)=
{.kw}
## `back`

```{index} single: back ($optimize)
```

**Type:** switch\
**Default:** `0`\
**Status:** current · verified on 25 (2025.02.28)\
**Sources:** version 25 test runs, `input.txt`, chemport.ru forum, LIMOR page

IRC direction. A full IRC takes two runs, one per direction: version 25 with the default `back=0`
followed one direction only (`n = 1, back = 0, down = 1` in the output), and `back=1` the other one
(negative `distance` values on the `IRC>` lines). Re-optimize the endpoints afterwards, because
an IRC does not end at a converged minimum.

```{tabularcolumns} \Y{0.3}\Y{0.7}
```

| Value | Meaning |
|---|---|
| `0` | Trace the IRC path forwards. (**default**) |
| `1` | Trace the IRC path backwards. |

**See also:** {ref}`points ($optimize) <optimize.points>`, {ref}`radius ($optimize) <optimize.radius>`

(optimize.points)=
{.kw}
## `points`

```{index} single: points ($optimize)
```

**Type:** integer\
**Default:** *none stated*\
**Status:** current · verified on 25 (2025.02.28)\
**Sources:** version 25 test runs, `input.txt`

Number of points to optimize in an IRC run, or number of constrained geometry optimizations in a scan run.
In a scan the points include both ends: `points=4` gives s = 0, 1/3, 2/3 and 1. An IRC can stop before
`points` is reached when it arrives at a minimum.

**See also:** {ref}`value ($optimize) <optimize.value>`

(optimize.radius)=
{.kw}
## `radius`

```{index} single: radius ($optimize)
```

**Type:** real\
**Default:** `0.1`\
**Status:** current · verified on 25 (2025.02.28)\
**Sources:** version 25 test runs, `input.txt`, `Dft.rtf`, chemport.ru forum

Radius, in mass-weighted coordinates, for IRC path optimization. Adjacent IRC points end up roughly twice
this distance apart. The IRC coordinate is reported in bohr·amu^1/2.

**About the default:** `0.1` as echoed by version 25 (`r = 0.1000000000`); `Dft.rtf` gives 0.2 (older version).

```{note}
`Vicinity of a Stationary Point(?) --- STOP.` ends an IRC that has reached the region of a minimum; in
version 25 it was the normal end of a test IRC. Users have also seen it early, when the energy did not
decrease on a step; changing the step size is the reported fix there. The other normal end is
`Energy Minimum Passed --- STOP.`, printed after a point that came out higher than the one before; in version
25 it sometimes followed the `Vicinity` message. In a version 25 IRC of HCN ⇄ HNC, `radius=0.03` and `0.1`
reached both minima (about 65 and 20 points per direction). `radius=0.3` was run towards HCN only: 7 points,
stopping farther from the minimum than the smaller radii.
```

(optimize.coordinates)=
{.kw}
## `coordinates`

```{index} single: coordinates ($optimize)
```

**Type:** list\
**Default:** *none stated*\
**Status:** current · verified on 25 (2025.02.28)\
**Sources:** version 25 test runs, `input.txt`, qchem.ru forum

List of redundant internal coordinates to use, each given as five integers.

**About the default:** generated automatically.

```{tabularcolumns} \Y{0.3}\Y{0.7}
```

| Value | Meaning |
|---|---|
| `1,i,j,0,0` | Distance i–j. |
| `2,i,j,k,0` | Angle i–j–k. |
| `3,i,j,k,l` | Torsion i–j–k–l. |
| `4,i,j,k,l` | Special coordinate for linear fragments. A user describes it as the angle between line l–k and the normal to plane k–j–i. |
| `5,i,j,k,l` | Special coordinate for linear fragments (meaning not described). |

```{note}
`input.txt` spells this keyword `coordinated=`, which is a typo: version 25 stops with `*** error in '$optimize' : unknown name coordinated`. Use `coordinates=`.
```

**See also:** {ref}`fix ($optimize) <optimize.fix>`

(optimize.fix)=
{.kw}
## `fix`

```{index} single: fix ($optimize)
```

**Type:** list\
**Default:** *none stated*\
**Status:** current · verified on 25 (2025.02.28)\
**Sources:** version 25 test runs, version 25 executable, `input.txt`, chemport.ru forum, qchem.ru forum, LIMOR page

Internal coordinates to keep fixed during the optimization, in the same five-integer format as
`coordinates`. Several entries are separated by commas or spaces.

```{note}
Users reported in 2010 that atoms could not be frozen in Cartesian space and that two coordinates could not be
constrained to stay equal. This was not checked in version 25, whose executable contains `$optimize` names of
unknown meaning (`fragment`, `weight`, `local`) and restraint groups (`$anchor`, `$confine`).
```

**See also:** {ref}`value ($optimize) <optimize.value>`, {ref}`coordinates ($optimize) <optimize.coordinates>`

(optimize.value)=
{.kw}
## `value`

```{index} single: value ($optimize)
```

**Type:** indexed-array\
**Default:** *none stated*\
**Units:** Å and degrees\
**Status:** current · verified on 25 (2025.02.28)\
**Sources:** version 25 test runs, `input.txt`, chemport.ru forum, qchem.ru forum

Values of the fixed internal coordinates. For `task=scan`, give all the initial values followed by all the
final values. `val(i)=` fills the list starting at position i, so values left unset keep their input-geometry
values.

**About the default:** computed from the input geometry.

```{note}
**Priroda's dihedral angles have the opposite sign to the convention used by Molden, MOPAC and GAMESS.** Flip
the sign of any torsion value taken from another program, or the scan starts from a mangled geometry.
```

**Example:**

```priroda
$optimize
 fix   =1,7,9,0,0, 1,8,10,0,0, 3,8,7,9,0, 3,10,9,7,0
 val(1)=1.6,       1.7
 val(5)=2.0,       2.1
 points=5
$end
# 5 optimizations: r(7-9) = 1.6 … 2.0, r(8-10) = 1.7 … 2.1;
# the last two fixed coordinates keep their input values
```

**See also:** {ref}`fix ($optimize) <optimize.fix>`, {ref}`points ($optimize) <optimize.points>`

(optimize.gradient)=
{.kw}
## `gradient`

```{index} single: gradient ($optimize)
```

**Type:** switch\
**Default:** *none stated*\
**Status:** current · not verified\
**Sources:** `input.txt`

Set `gradient=0` when the starting second derivatives were computed with a different method or basis set.
This excludes the gradient terms from the internal/Cartesian transformation at the first geometry.
Otherwise keep the default.

(optimize.print)=
{.kw}
## `print`

```{index} single: print ($optimize)
```

**Type:** switch\
**Default:** *none stated*\
**Status:** current · not verified\
**Sources:** `input.txt`

Amount of optimization output.

```{tabularcolumns} \Y{0.3}\Y{0.7}
```

| Value | Meaning |
|---|---|
| `0` | Minimal. |
| `1` | Detailed |

(optimize.symmetry)=
{.kw}
## `symmetry`

```{index} single: symmetry ($optimize)
```

**Type:** switch\
**Default:** *none stated*\
**Status:** undocumented · verified on 25 (2025.02.28)\
**Sources:** version 25 test runs, version 25 executable, official site files, chemport.ru forum

Keeps point-group symmetry during the optimization (the optimizer switches to Cartesian coordinates); needs
`$molecule sym=` as well. The official 2023–2025 example inputs write it as the prefix `sym=1`. In version 25,
together with `$molecule sym=1,0.01`, the optimizer switched to Cartesian coordinates (`Coordinates: cartesian`), printed `symmetry: C3v (6)` at
every step, and returned an exactly symmetric structure followed by `MOL> symmetry: C3v`. Without
`$molecule sym=`, `$optimize sym=1` only switches to Cartesian coordinates and reports `symmetry: C1 (1)`,
so give both options.

**See also:** {ref}`sym ($molecule) <molecule.sym>`

(optimize.model)=
{.kw}
## `model`

```{index} single: model ($optimize)
```

**Type:** integer\
**Default:** *none stated*\
**Status:** undocumented · not verified\
**Sources:** version 25 executable, official site files

Used as `mod=1` with `task=opt_n1` (very large systems). In version 25, `model` is read only by the separate
optimizer of `task=opt_n1`, together with `function`, `h0`, `delta`, `fragment`, `steps`, `trust`,
`tolerance` and `print`. Meaning not documented.
