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
**Default:** `0`\
**Status:** current · verified on 25 (2025.02.28)\
**Sources:** input.txt; Dft.rtf (default); 04 #306; 05 §5, §7; 08 t27, t71b

Default: `read=0` is the default in `Dft.rtf`. Version 25 without `read=1` prints `Initial Guess (2)`, the normal guess.

Source of the starting SCF vectors.

```{tabularcolumns} \Y{0.3}\Y{0.7}
```

| Value | Meaning |
|---|---|
| `1` | Read SCF vectors from the file named by `$control save=`. |
| `0` | Extended Hückel guess. (**default**) |

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
**Status:** current · verified on 25 (2025.02.28)\
**Sources:** input.txt; 08 t74e; 08 t75b; 08 t75d

Default: `na(1)=1,2,3,…,N` (the natural order).

Reordering of the starting vectors for alpha spin.

```{note}
Accepted in version 25, also together with `read=1`, where it reorders the vectors read from the file. For
closed-shell water, swapping the HOMO and LUMO only slowed the SCF: it returned to the ground state. The
effect was seen only in the iteration counts, as the output does not print the reordering.
```

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
**Status:** current · verified on 25 (2025.02.28)\
**Sources:** input.txt; 08 t74e; 08 t75b

Default: `nb(1)=1,2,3,…,N`.

Reordering of the starting vectors for beta spin.

```{note}
Accepted in version 25 together with `na`; as for `na`, the output does not print the reordering.
```

**See also:** {ref}`na ($guess) <guess.na>`

(guess.mix)=
## `mix`

```{index} single: mix ($guess)
```

**Type:** switch\
**Default:** `0`\
**Status:** current · verified on 25 (2025.02.28)\
**Sources:** input.txt (annotation corrupted); 03 #0, §7; 06 §3 (default 0); 08 t60, t73, t74a-d, t79, round 14

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
RKS). One user saw a lower unrestricted energy with RI-PBE and RI-BLYP, but only by about 3·10⁻⁶ hartree,
which is close to the SCF convergence threshold. In version 25, `mix=1` with
`restrict=0` returned to the restricted solution for singlet O2 (PBE and RI-PBE1) and for Cr2 (PBE, default
and BFGS procedures): no broken-symmetry solution was found in any test. Stretched H2 (2.5 Å) with UHF or
UKS also stayed restricted with `mix=1`, `2`, `-1`, `10`, `45` or `90`, with or without `read=1`, although
the triplet lies 0.13 hartree lower. So in version 25 `mix` is accepted (integers only; `mix=0.5` is an
input error) but had no visible effect. Starting the singlet from saved triplet vectors (`read=1`) did reach
a broken-symmetry singlet for O2, 0.048 hartree below the restricted one; it needed more than the default 32
iterations (`iterations=300`). This did not work for H2.
```

**See also:** {ref}`restrict ($scf) <scf.restrict>`
