<!-- Generated from keywords/thermo.yaml by docs/_ext/priroda_keywords.py. Do not edit. -->


(group.thermo)=
# `$thermo`

```{index} single: $thermo
```

Thermochemistry after a Hessian calculation.

(thermo.sigma)=
## `sigma`

```{index} single: sigma ($thermo)
```

**Type:** integer\
**Default:** *none stated*\
**Status:** current · not verified\
**Sources:** input.txt

Rotational symmetry number for thermochemistry.

(thermo.temperature)=
## `temperature`

```{index} single: temperature ($thermo)
```

**Type:** list\
**Default:** *none stated*\
**Units:** K\
**Status:** current · not verified\
**Sources:** input.txt; Dft.rtf

Default: `298.15` according to `Dft.rtf`, but posted outputs show `298.000 K` (2011, 2021) as well as `298.150 K` (2013).
Set `temperature=` explicitly when the exact value matters.


Temperatures at which thermochemistry is printed, up to 50 values.

(thermo.mass)=
## `mass`

```{index} single: mass ($thermo)
```

**Type:** list\
**Default:** *none stated*\
**Units:** amu\
**Status:** undocumented · not verified\
**Sources:** Dft.rtf

Atomic masses for vibrational analysis and thermochemistry. Use it to redo the analysis for other isotopes
from a stored Hessian (`$Energy`) without recomputing it.

**See also:** {ref}`mass ($molecule) <molecule.mass>`, {ref}`H ($Energy) <Energy.H>`
