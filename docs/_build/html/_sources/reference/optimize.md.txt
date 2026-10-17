<!-- Generated from keywords/optimize.yaml by docs/_ext/priroda_keywords.py. Do not edit. -->


(group.optimize)=
# `$optimize`

```{index} single: $optimize
```

Geometry optimization, saddle-point search, IRC and relaxed scans.

**Relevant when:** `task = optimize | optimize+hessian | irc | scan | opt_n1`

(optimize.saddle)=
## `saddle`

```{index} single: saddle ($optimize)
```

**Type:** switch\
**Default:** `0`\
**Status:** current · not verified\
**Sources:** input.txt; Dft.rtf; 04 #216; 03 §9

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
`task=hessian` to confirm one imaginary frequency → IRC.
```

**See also:** {ref}`follow ($optimize) <optimize.follow>`, {ref}`H ($Energy) <Energy.H>`

(optimize.tolerance)=
## `tolerance`

```{index} single: tolerance ($optimize)
```

**Type:** list\
**Default:** `0.0001,0.01`\
**Units:** au\
**Status:** current · not verified\
**Sources:** input.txt; 01 §4.6 (output echo)

Default: if only the first value is given, the second is 100 times larger (the recommended setting).

Convergence tolerance on the gradient (first value) and on the displacement (second value).

**See also:** {ref}`accuracy ($grid) <grid.accuracy>`

(optimize.trust)=
## `trust`

```{index} single: trust ($optimize)
```

**Type:** list\
**Default:** `0.2,0.0125`\
**Status:** current · not verified\
**Sources:** input.txt; 01 §4.6; 04 #319; Dft.rtf

Default: echoed by v6, v13 and v15 as `Trust radius = 0.2 (max), 0.0125 (min)` in internal coordinates, and 0.1 / 0.00625
with `cartesian=1`. If only the maximum is given, the minimum is 1/16 of it and the initial value 1/4.
`Dft.rtf` gives 0.5 (older version).


Trust radius (the largest allowed step), given as maximum, minimum and initial values.

(optimize.follow)=
## `follow`

```{index} single: follow ($optimize)
```

**Type:** integer\
**Default:** *none stated*\
**Status:** current · not verified\
**Sources:** input.txt; Dft.rtf

Default: `1` according to `Dft.rtf`.

Follow the n-th Hessian eigenvector in a saddle-point search.

**See also:** {ref}`saddle ($optimize) <optimize.saddle>`

(optimize.steps)=
## `steps`

```{index} single: steps ($optimize)
```

**Type:** integer\
**Default:** `50`\
**Status:** current · not verified\
**Sources:** input.txt; Dft.rtf; 03 §8 (step/steps bug)

Maximum number of optimization cycles.

```{note}
If an optimization has not converged within about 50 steps, something is probably wrong; raising `steps`
rarely helps. Computing a Hessian first and supplying it often does. In v6, if both `steps` and `step` are
given, the value of `step` is used; give only one of them.
```

**See also:** {ref}`tolerance ($optimize) <optimize.tolerance>`, {ref}`steps ($d2edr2) <d2edr2.steps>`

(optimize.cartesian)=
## `cartesian`

```{index} single: cartesian ($optimize)
```

**Type:** switch\
**Default:** `0`\
**Status:** current · not verified\
**Sources:** input.txt; 01 §4.6; 04 #518

Coordinate system for the optimization. The output reports `Coordinates: internal` or `cartesian`.

```{tabularcolumns} \Y{0.3}\Y{0.7}
```

| Value | Meaning |
|---|---|
| `0` | Redundant internal coordinates. (**default**) |
| `1` | Cartesian coordinates (last resort). |

```{note}
`cartesian=1` is the fix when the program crashes with `process 0 got signal 6` after a `too few` message in
the internal-coordinate table.
```

(optimize.back)=
## `back`

```{index} single: back ($optimize)
```

**Type:** switch\
**Default:** `0`\
**Status:** current · not verified\
**Sources:** input.txt; 02 §3.2; 04 §0

IRC direction. A full IRC takes two runs, one per direction. Re-optimize the endpoints afterwards, because
an IRC does not end at a converged minimum.

```{tabularcolumns} \Y{0.3}\Y{0.7}
```

| Value | Meaning |
|---|---|
| `0` | Trace the IRC path forwards. (**default**) |
| `1` | Trace the IRC path backwards. |

**See also:** {ref}`points ($optimize) <optimize.points>`, {ref}`radius ($optimize) <optimize.radius>`

(optimize.points)=
## `points`

```{index} single: points ($optimize)
```

**Type:** integer\
**Default:** *none stated*\
**Status:** current · not verified\
**Sources:** input.txt

Number of points to optimize in an IRC run, or number of constrained geometry optimizations in a scan run.

**See also:** {ref}`value ($optimize) <optimize.value>`

(optimize.radius)=
## `radius`

```{index} single: radius ($optimize)
```

**Type:** real\
**Default:** *none stated*\
**Status:** current · not verified\
**Sources:** input.txt; Dft.rtf; 04 #298

Default: `0.2` according to `Dft.rtf` (older version).

Radius, in mass-weighted coordinates, for IRC path optimization. Adjacent IRC points end up roughly twice
this distance apart. The IRC coordinate is reported in bohr·amu^1/2.

```{note}
`Vicinity of a Stationary Point(?) --- STOP.` during an IRC means the energy did not decrease on that step.
Changing the step size is the reported fix.
```

(optimize.coordinates)=
## `coordinates`

```{index} single: coordinates ($optimize)
```

**Type:** list\
**Default:** *none stated*\
**Status:** current · not verified\
**Sources:** input.txt; 03 §5 (type 4)

Default: generated automatically.

List of redundant internal coordinates to use, each given as five integers.

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
`input.txt` spells this keyword `coordinated=` (apparently a typo). Verify the accepted spelling.
```

**See also:** {ref}`fix ($optimize) <optimize.fix>`

(optimize.fix)=
## `fix`

```{index} single: fix ($optimize)
```

**Type:** list\
**Default:** *none stated*\
**Status:** current · not verified\
**Sources:** input.txt; 02 §3.2; 03 §5 (wish list); 04 #372-#373

Internal coordinates to keep fixed during the optimization, in the same five-integer format as
`coordinates`. Several entries are separated by commas or spaces.

```{note}
Atoms cannot be frozen in Cartesian space; only internal coordinates can be fixed. Two coordinates also cannot
be constrained to stay equal.
```

**See also:** {ref}`value ($optimize) <optimize.value>`, {ref}`coordinates ($optimize) <optimize.coordinates>`

(optimize.value)=
## `value`

```{index} single: value ($optimize)
```

**Type:** indexed-array\
**Default:** *none stated*\
**Units:** Å and degrees\
**Status:** current · not verified\
**Sources:** input.txt; 03 §5, §8; 04 #278-#279, #373

Default: computed from the input geometry.

Values of the fixed internal coordinates. For `task=scan`, give all the initial values followed by all the
final values. `val(i)=` fills the list starting at position i, so values left unset keep their input-geometry
values.

```{note}
**Priroda's dihedral angles have the opposite sign to the convention used by Molden, MOPAC and GAMESS.** Flip
the sign of any torsion value taken from another program, or the scan starts from a mangled geometry.
```

**Example:**

```text
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
## `gradient`

```{index} single: gradient ($optimize)
```

**Type:** switch\
**Default:** *none stated*\
**Status:** current · not verified\
**Sources:** input.txt

Set `gradient=0` when the starting second derivatives were computed with a different method or basis set.
This excludes the gradient terms from the internal/Cartesian transformation at the first geometry.
Otherwise keep the default.

(optimize.print)=
## `print`

```{index} single: print ($optimize)
```

**Type:** switch\
**Default:** *none stated*\
**Status:** current · not verified\
**Sources:** input.txt

Amount of optimization output.

```{tabularcolumns} \Y{0.3}\Y{0.7}
```

| Value | Meaning |
|---|---|
| `0` | Minimal. |
| `1` | Detailed |

(optimize.sym)=
## `sym`

```{index} single: sym ($optimize)
```

**Type:** switch\
**Default:** *none stated*\
**Status:** undocumented · not verified\
**Sources:** 01 §4.6; 04 #481

Used as `sym=1` in the author's 2023–2025 inputs, apparently to preserve molecular symmetry during the optimization.

**See also:** {ref}`sym ($molecule) <molecule.sym>`

(optimize.mod)=
## `mod`

```{index} single: mod ($optimize)
```

**Type:** integer\
**Default:** *none stated*\
**Status:** undocumented · not verified\
**Sources:** 01 §4.6

Used as `mod=1` with `task=opt_n1` (very large systems). Meaning not documented.
