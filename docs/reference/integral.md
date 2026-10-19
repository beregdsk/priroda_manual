<!-- Generated from keywords/integral.yaml by docs/_ext/priroda_keywords.py. Do not edit. -->


(group.integral)=
# `$integral`

```{index} single: $integral
```

Integral evaluation for RI methods.

(integral.direct)=
## `direct`

```{index} single: direct ($integral)
```

**Type:** switch\
**Default:** `0`\
**Status:** undocumented · not verified\
**Sources:** `input.txt`, chemport.ru forum, qchem.ru forum

Selects direct (recomputed) Coulomb integrals for RI methods.

```{tabularcolumns} \Y{0.3}\Y{0.7}
```

| Value | Meaning |
|---|---|
| `0` | Store integrals. (**default**) |
| `1` | Recompute Coulomb integrals (direct mode) in `theory=rimp2` and `theory=ridft`. |

```{note}
Direct mode roughly halves disk use, but it is slower. It is also the reported workaround when a small RI-MP2
job claims not to fit in memory, or crashes with `write VMNN(…)?`.
```

**Example:**

```text
$integral direct=1 rout=2 $end
```

(integral.routine)=
## `routine`

```{index} single: routine ($integral)
```

**Type:** integer\
**Default:** `0`\
**Status:** undocumented · not verified\
**Sources:** `input.txt`, qchem.ru forum

Algorithm for the two-electron integrals in correlated methods. `input.txt`'s example uses `rout=2`, but no
source explains the value 2.

```{tabularcolumns} \Y{0.3}\Y{0.7}
```

| Value | Meaning |
|---|---|
| `0` | Default algorithm. (**default**) |
| `1` | Slightly slower but parallelizes better over many processes. |
