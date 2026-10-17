<!-- Generated from keywords/d2edr2.yaml by docs/_ext/priroda_keywords.py. Do not edit. -->


(group.d2edr2)=
# `$d2edr2`

```{index} single: $d2edr2
```

Numerical Hessian by finite differences of the gradient.

(d2edr2.length)=
## `length`

```{index} single: length ($d2edr2)
```

**Type:** real\
**Default:** *none stated*\
**Status:** current · not verified\
**Sources:** input.txt

Step length for numerical differentiation of the potential-energy surface.

(d2edr2.displace)=
## `displace`

```{index} single: displace ($d2edr2)
```

**Type:** switch\
**Default:** `2`\
**Status:** current · not verified\
**Sources:** input.txt

Number of displacements per coordinate. More accurate numerical Hessians may also need tighter SCF convergence.

```{tabularcolumns} \Y{0.3}\Y{0.7}
```

| Value | Meaning |
|---|---|
| `1` | One displacement per coordinate. |
| `2` | Two displacements per coordinate. More accurate but twice as slow. (**default**) |

**See also:** {ref}`convergence ($scf) <scf.convergence>`

(d2edr2.steps)=
## `steps`

```{index} single: steps ($d2edr2)
```

**Type:** list\
**Default:** `0,-1`\
**Status:** current · not verified\
**Sources:** input.txt

Default: `0,-1` runs every step from 0 to 3N (or 6N) in a single run.

The first and last displacement steps to do in this run. The reference geometry is step 0, and the displaced
geometries are 1 … 3N (one displacement) or 1 … 6N (two displacements). This lets a numerical Hessian be split
across separate runs and then combined.

```{note}
Not the same keyword as `$optimize steps`.
```

**Example:**

```text
# 12-atom molecule, four inputs run in parallel on different machines:
$d2edr2 disp=1 steps= 0, 9 $end    # mol.in1
$d2edr2 disp=1 steps=10,18 $end    # mol.in2
$d2edr2 disp=1 steps=19,27 $end    # mol.in3
$d2edr2 disp=1 steps=28,36 $end    # mol.in4
# collect the partial results into one input:
grep "num>" mol.out{1,2,3,4} | sed "s/\.*num>//g" >> mol.in
# add the line below and run once more to process them:
$d2edr2 steps=-1 $end
```
