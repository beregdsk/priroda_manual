<!-- Generated from keywords/nmr.yaml by docs/_ext/priroda_keywords.py. Do not edit. -->


(group.nmr)=
# `$nmr`

```{index} single: $nmr
```

Reference shieldings and extra points for NMR shielding calculations.

**Relevant when:** `task = nmr (theory = dft only)`

(nmr.standard)=
## `standard`

```{index} single: standard ($nmr)
```

**Type:** indexed-array\
**Default:** *none stated*\
**Status:** current · verified on 25 (2025.02.28)\
**Sources:** input.txt; 04 #69; 02 §5.7; 08 t34; 08 t57b

Reference shielding constants, indexed by atomic number, for computing chemical shifts. Values are needed
only for the elements present in the molecule.

```{note}
A reference shielding is only valid for the method, basis set and grid it was computed with. Users quote
different TMS values (e.g. `standard(1)=31.3867 standard(6)=181.9781`) for other settings. Compute TMS with
exactly the settings of the production run. Without `standard`, version 25 prints `shift=` as minus the
isotropic shielding; with it, `shift = standard − isotropic shielding`.
```

**Example:**

```text
$nmr
 standard(1)=31.3915
 standard(6)=181.9921
$end
# computed for Si(CH3)4; usable for a series of hydrocarbons
```

(nmr.points)=
## `points`

```{index} single: points ($nmr)
```

**Type:** list\
**Default:** *none stated*\
**Units:** Å\
**Status:** current · not verified\
**Sources:** input.txt; 02 §3.2; 03 §12

Extra points in space, given as x,y,z triples, at which magnetic shielding tensors are computed in
addition to the nuclear centres. This is the way to compute NICS: NICS is the negative of the isotropic
shielding printed for the point.

**Example:**

```text
$nmr
 points=
      0.00000000    0.00000000    0.00000000
      0.00000000    0.00000000    1.00000000
$end
```
