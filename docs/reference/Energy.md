<!-- Generated from keywords/energy.yaml by docs/_ext/priroda_keywords.py. Do not edit. -->


(group.Energy)=
# `$Energy`

```{index} single: $Energy
```

Results of an earlier run (energy, gradient, Hessian, dipole data), read back as input.

The program prints this group on lines prefixed with `eng>` (an energy, gradient or Hessian run) or `num>`.
`num>` lines come from `task=dipole` (one `$Energy` group with `A=`, `Dx=` and `Ax=`) and from numerical Hessians,
which write one numbered group per displacement: `$Energy000`, `$Energy001`, … (see `$d2edr2 steps`). Strip the
prefix and append the groups to the next input. The helper script `ge` on the official site does this.

A stored Hessian is required for `$optimize saddle=1` and `task=irc`. It also speeds up difficult minimizations,
and it lets you redo vibrational analysis or thermochemistry (for example for other isotopes, `$thermo mass=`)
without recomputing.

```text
eng>$Energy
eng> E=-2.284057276940e+03
eng> D= 4.22290114e-08 -1.82061636e-08  2.32661117e-08
eng> G= 5.13271929e-06 -5.52234429e-06 -6.15997899e-06
eng>    ...
eng>$end
```

(Energy.E)=
## `E`

```{index} single: E ($Energy)
```

**Type:** real\
**Default:** *none stated*\
**Units:** hartree\
**Status:** undocumented · verified on 25 (2025.02.28)\
**Sources:** version 25 test runs, official site files, LIMOR page

Total energy.

(Energy.G)=
## `G`

```{index} single: G ($Energy)
```

**Type:** list\
**Default:** *none stated*\
**Units:** au\
**Status:** undocumented · verified on 25 (2025.02.28)\
**Sources:** version 25 test runs, official site files, LIMOR page

Cartesian gradient (3N values).

(Energy.H)=
## `H`

```{index} single: H ($Energy)
```

**Type:** list\
**Default:** *none stated*\
**Units:** au\
**Status:** undocumented · verified on 25 (2025.02.28)\
**Sources:** version 25 test runs, LIMOR page

Hessian as a lower triangle, 3N(3N+1)/2 values. Written by `task=hessian` on `eng>` lines; in version 25 a
`saddle=1` optimization and an IRC read it back from an appended `$Energy` group. If the input holds several
plain `$Energy` groups, the last one is used. The numbered groups `$Energy000`, `$Energy001`, … of a split
numerical Hessian are all read by the combining run (`$d2edr2 steps=-1`).

**See also:** {ref}`saddle ($optimize) <optimize.saddle>`, {ref}`steps ($d2edr2) <d2edr2.steps>`

(Energy.D)=
## `D`

```{index} single: D ($Energy)
```

**Type:** list\
**Default:** *none stated*\
**Units:** au\
**Status:** undocumented · verified on 25 (2025.02.28)\
**Sources:** version 25 test runs, official site files, LIMOR page

Dipole moment (3 values), written next to `E=`.

(Energy.Dx)=
## `Dx`

```{index} single: Dx ($Energy)
```

**Type:** list\
**Default:** *none stated*\
**Status:** undocumented · not verified\
**Sources:** version 25 test runs, LIMOR page

Dipole derivatives with respect to nuclear coordinates (inferred from use: IR/Raman intensities).

(Energy.A)=
## `A`

```{index} single: A ($Energy)
```

**Type:** list\
**Default:** *none stated*\
**Status:** undocumented · not verified\
**Sources:** version 25 test runs, LIMOR page

Static dipole polarizability as a lower triangle (6 values), written with a negative sign (inferred: the
second derivative of the energy with respect to the field). Written by an analytic Hessian (`eng>`) and by
`task=dipole` (`num>`).

**See also:** {ref}`Ax ($Energy) <Energy.Ax>`

(Energy.Ax)=
## `Ax`

```{index} single: Ax ($Energy)
```

**Type:** list\
**Default:** *none stated*\
**Status:** undocumented · verified on 25 (2025.02.28)\
**Sources:** version 25 test runs, version 25 executable, chemport.ru forum

Polarizability derivatives with respect to the nuclear coordinates. Written by `task=dipole` on `num>` lines;
appended to a Hessian input, they give the Raman activities and depolarization ratios.

**See also:** {ref}`A ($Energy) <Energy.A>`, {ref}`Dx ($Energy) <Energy.Dx>`
