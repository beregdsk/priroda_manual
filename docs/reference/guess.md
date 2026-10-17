<!-- Generated from keywords/guess.yaml by docs/_ext/priroda_keywords.py. Do not edit. -->


(group.guess)=
# `$guess`

```{index} single: $guess
```

Initial guess for the SCF vectors.

(guess.read)=
## `read`

```{index} single: read ($guess)
```

**Type:** switch\
**Default:** *none stated*\
**Status:** current · verified on 25 (2025.02.28)\
**Sources:** input.txt; 04 #306; 05 §1; 08 t27

Source of the starting SCF vectors.

```{tabularcolumns} \Y{0.3}\Y{0.7}
```

| Value | Meaning |
|---|---|
| `1` | Read SCF vectors from the file named by `$control save=`. |
| `0` | Extended Hückel guess. |

```{note}
Reading saved vectors is the standard way to restart a stalled SCF, and to reuse converged orbitals in a
follow-up job such as a Hessian after an optimization.
```

**See also:** {ref}`save ($control) <control.save>`, {ref}`iterations ($scf) <scf.iterations>`

(guess.na)=
## `na`

```{index} single: na ($guess)
```

**Type:** indexed-array\
**Default:** *none stated*\
**Status:** current · not verified\
**Sources:** input.txt

Default: `na(1)=1,2,3,…,N` (the natural order).

Reordering of the starting vectors for alpha spin.

**Example:**

```text
$guess na(25)=26,25 $end    # swap the 25th and 26th vectors
```

**See also:** {ref}`nb ($guess) <guess.nb>`

(guess.nb)=
## `nb`

```{index} single: nb ($guess)
```

**Type:** indexed-array\
**Default:** *none stated*\
**Status:** current · not verified\
**Sources:** input.txt

Default: `nb(1)=1,2,3,…,N`.

Reordering of the starting vectors for beta spin.

**See also:** {ref}`na ($guess) <guess.na>`

(guess.mix)=
## `mix`

```{index} single: mix ($guess)
```

**Type:** switch\
**Default:** `0`\
**Status:** undocumented · not verified\
**Sources:** input.txt (annotation corrupted); 03 #0, §7; 06 §3

Breaks the equivalence of the alpha and beta electrons in the highest occupied orbital. It is meant for
open-shell singlets (for example singlet biradicals) and is only sensible with `$scf restrict=0`.

```{tabularcolumns} \Y{0.3}\Y{0.7}
```

| Value | Meaning |
|---|---|
| `0` | No mixing. (**default**) |
| `1` | Mix the HOMO and LUMO to break alpha/beta equivalence. |

```{note}
Users report that with non-RI DFT, `mix=1` can converge back to the restricted solution (same energy as
RKS). RI-DFT, or a hybrid, broke the symmetry in the reported cases.
```

**See also:** {ref}`restrict ($scf) <scf.restrict>`
