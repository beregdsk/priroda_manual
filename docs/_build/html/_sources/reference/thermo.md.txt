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
**Default:** `1`\
**Status:** current · verified on 25 (2025.02.28)\
**Sources:** input.txt; 08 t13

Default: 1 (version 25 does not detect the symmetry number).

Rotational symmetry number for thermochemistry. Version 25 does not detect it and uses 1 unless `sigma=` is
given, which overestimates the rotational entropy by R ln σ (2.18 cal/(mol·K) for NH3, σ = 3).

(thermo.temperature)=
## `temperature`

```{index} single: temperature ($thermo)
```

**Type:** list\
**Default:** `298.15`\
**Units:** K\
**Status:** current · verified on 25 (2025.02.28)\
**Sources:** input.txt; Dft.rtf; 08 t13

Default: `298.15`: version 25 prints `T =  298.150 K`, as `Dft.rtf` states. Older posted outputs also show `298.000 K`
(2011, 2021), so set `temperature=` explicitly when comparing with other versions.


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
