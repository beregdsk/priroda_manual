<!-- Generated from keywords/d2edr2.yaml by docs/_ext/priroda_keywords.py. Do not edit. -->


(group.d2edr2)=
# `$d2edr2`

```{index} single: $d2edr2
```

Numerical Hessian by finite differences of the gradient.

**Relevant when:** `numerical Hessian: task = hessian with theory = ridft | rimp2 | tddft | qm_n3, or $control derivative = numeric (an analytic dft Hessian has no displacement steps)`

(d2edr2.length)=
## `length`

```{index} single: length ($d2edr2)
```

**Type:** real\
**Default:** `0.001`\
**Units:** au (bohr)\
**Status:** current · verified on 25 (2025.02.28)\
**Sources:** version 25 test runs, `input.txt`

Step length for numerical differentiation of the potential-energy surface.

**About the default:** version 25 prints `Step 0.00100000 au FORWARD  for coordinate   1:` for each displacement.

(d2edr2.displace)=
## `displace`

```{index} single: displace ($d2edr2)
```

**Type:** switch\
**Default:** `2`\
**Status:** current · verified on 25 (2025.02.28)\
**Sources:** version 25 test runs, `input.txt`

Number of displacements per coordinate. More accurate numerical Hessians may also need tighter SCF convergence.

```{tabularcolumns} \Y{0.3}\Y{0.7}
```

| Value | Meaning |
|---|---|
| `1` | One displacement per coordinate. |
| `2` | Two displacements per coordinate. More accurate but twice as slow. (**default**) |

```{note}
With the default, version 25 printed a FORWARD and a BACKWARD step for every coordinate.
```

**See also:** {ref}`convergence ($scf) <scf.convergence>`

(d2edr2.steps)=
## `steps`

```{index} single: steps ($d2edr2)
```

**Type:** list\
**Default:** `0,-1`\
**Status:** current · verified on 25 (2025.02.28)\
**Sources:** version 25 test runs, `input.txt`

The first and last displacement steps to do in this run. The reference geometry is step 0, and the displaced
geometries are 1 … 3N (one displacement) or 1 … 6N (two displacements). This lets a numerical Hessian be split
across separate runs and then combined.

**About the default:** `0,-1` runs every step from 0 to 3N (or 6N) in a single run.

```{note}
Not the same keyword as `$optimize steps`. Tested in version 25 with water (`ridft`, `displace=1`, steps 0–9):
two partial runs (`steps=0,4`, `steps=5,9`) and a combining run with `displace=1 steps=-1` gave the same
frequencies, to within 0.4 cm⁻¹, as a one-run Hessian with the default `displace=2`. The combining run does no
SCF. Each part writes one numbered group per displacement (`$Energy000`, `$Energy001`, …) on `num>` lines. The collecting command in `input.txt`
(`grep "num>" … | sed "s/\.*num>//g"`) leaves the file names that `grep` adds at the start of each line;
the example uses `grep -h` instead.
```

**Example:**

```text
# 12-atom molecule, four inputs run in parallel on different machines:
$d2edr2 disp=1 steps= 0, 9 $end    # mol.in1
$d2edr2 disp=1 steps=10,18 $end    # mol.in2
$d2edr2 disp=1 steps=19,27 $end    # mol.in3
$d2edr2 disp=1 steps=28,36 $end    # mol.in4
# collect the partial results into one input:
grep -h "^num>" mol.out1 mol.out2 mol.out3 mol.out4 | sed 's/^num>//' >> mol.in
# in mol.in, replace the $d2edr2 line with the one below and run once more to process them:
$d2edr2 disp=1 steps=-1 $end
```

**See also:** {ref}`E ($Energy) <Energy.E>`
