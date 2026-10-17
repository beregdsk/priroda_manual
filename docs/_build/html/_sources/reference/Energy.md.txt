<!-- Generated from keywords/energy.yaml by docs/_ext/priroda_keywords.py. Do not edit. -->


(group.Energy)=
# `$Energy`

```{index} single: $Energy
```

Results of an earlier run (energy, gradient, Hessian, dipole data), read back as input.

The program prints this group on lines prefixed with `eng>` (an energy/gradient/Hessian run), or `num>` (the
pieces of a distributed numerical Hessian; see `$d2edr2 steps`). Strip the prefix and append the group to the
next input. The shipped helper script `ge` does this.

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
**Status:** undocumented · not verified\
**Sources:** 01 §4.10; 02 §3.2

Total energy.

(Energy.G)=
## `G`

```{index} single: G ($Energy)
```

**Type:** list\
**Default:** *none stated*\
**Units:** au\
**Status:** undocumented · not verified\
**Sources:** 01 §4.10; 02 §3.2

Cartesian gradient (3N values).

(Energy.H)=
## `H`

```{index} single: H ($Energy)
```

**Type:** list\
**Default:** *none stated*\
**Units:** au\
**Status:** undocumented · verified on 25 (2025.02.28)\
**Sources:** 02 §3.2; 08 t24, t25

Hessian as a lower triangle, 3N(3N+1)/2 values. Written by `task=hessian` on `eng>` lines; in version 25 a
`saddle=1` optimization and an IRC read it back from an appended `$Energy` group.

**See also:** {ref}`saddle ($optimize) <optimize.saddle>`

(Energy.D)=
## `D`

```{index} single: D ($Energy)
```

**Type:** list\
**Default:** *none stated*\
**Units:** au\
**Status:** undocumented · not verified\
**Sources:** 01 §4.10; 02 §3.2 (inferred)

Dipole moment.

(Energy.Dx)=
## `Dx`

```{index} single: Dx ($Energy)
```

**Type:** list\
**Default:** *none stated*\
**Status:** undocumented · not verified\
**Sources:** 02 §3.2 (inferred)

Dipole derivatives with respect to nuclear coordinates (inferred from use: IR/Raman intensities).

(Energy.A)=
## `A`

```{index} single: A ($Energy)
```

**Type:** list\
**Default:** *none stated*\
**Status:** undocumented · not verified\
**Sources:** 02 §3.2 (inferred); 04 #381

Polarizability, and its derivatives after `task=dipole` (inferred; used for Raman intensities).
