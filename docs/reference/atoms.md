<!-- Generated from keywords/atoms.yaml by docs/_ext/priroda_keywords.py. Do not edit. -->


(group.atoms)=
# `$atoms`

```{index} single: $atoms
```

Per-element core definitions for correlated (HF-based) methods.

(atoms.core)=
## `core`

```{index} single: core ($atoms)
```

**Type:** indexed-array\
**Default:** *none stated*\
**Status:** current · verified on 25 (2025.02.28)\
**Sources:** input.txt; 08 t16

For HF-based methods, the number of core shells for L=0,1,2,3, given for each atomic number. The values are
used only to compute the total number of core electrons in the molecule.

```{note}
The index is 10·Z: `core(280)` is nickel, `core(80)` oxygen. In version 25, `core(80)=0,0,0,0` removed the
oxygen 1s from the frozen core of an RI-MP2 run. The output reports the frozen core as `atom   8 core =  1`
and `Number of core electrons 1`; the number there counts core orbitals, not electrons.
```

**Example:**

```text
$atoms core(280)=2,1,0,0 $end
# 1s, 2s, 2p (10 electrons) of nickel are core
```

**See also:** {ref}`core ($scf) <scf.core>`, {ref}`mcore ($atoms) <atoms.mcore>`

(atoms.mcore)=
## `mcore`

```{index} single: mcore ($atoms)
```

**Type:** integer\
**Default:** *none stated*\
**Status:** current · not verified\
**Sources:** input.txt

A simple way to add outer-core shells to the correlation treatment: `mcore=M` adds all shells whose principal
quantum number is lower than that of the outermost valence shell by less than M.

**See also:** {ref}`core ($atoms) <atoms.core>`
