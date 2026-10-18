<!-- Generated from keywords/scf.yaml by docs/_ext/priroda_keywords.py. Do not edit. -->


(group.scf)=
# `$scf`

```{index} single: $scf
```

Spin restriction, convergence, iteration limits and SCF solver.

(scf.restrict)=
## `restrict`

```{index} single: restrict ($scf)
```

**Type:** switch\
**Default:** *none stated*\
**Status:** current · verified on 25 (2025.02.28)\
**Sources:** input.txt; 08 t48

Default: `1` for a closed-shell singlet, otherwise `0`. Version 25 ran O2 with `mult=3` (an even number of electrons) unrestricted without being told.

Spin restriction.

```{tabularcolumns} \Y{0.3}\Y{0.7}
```

| Value | Meaning |
|---|---|
| `0` | Spin-unrestricted. |
| `1` | Spin-restricted (available only for a few methods). |

**See also:** {ref}`mix ($guess) <guess.mix>`

(scf.convergence)=
## `convergence`

```{index} single: convergence ($scf)
```

**Type:** list\
**Default:** `1e-6,1e-3`\
**Status:** current · verified on 25 (2025.02.28)\
**Sources:** input.txt; 01 §4.5 (output echo, energy gradient); 05 §5.1; 04 #322-#324; 08 t01, t07a, t07b; 08 t22a-c; 08 t74b (gradient vs threshold); 08 Slurm (erations); 08 review check (convergence value series)

Default: the first value is for SCF and the second for CP-SCF.

SCF and CP-SCF convergence thresholds. The SCF value is a threshold on the energy gradient: in version
25, an SCF whose gradient stayed near 2·10⁻⁶ ended with `no convergence!` at the default 1e-6. The defaults
are recommended. To save time in difficult cases you may
loosen the SCF value to `1e-5` for preliminary geometry optimizations.

```{note}
**Put `iterations=` before `convergence=`, or give `convergence` two values.** A one-value `convergence=`
followed by `iterations=` stops the run with `*** error in '$scf' : unknown name terations`, also when the
two keywords are on separate lines. The message names `iterations` with its first letters missing; how many
depended on the machine, not on the value (`terations` on one computer, `erations` with `p4_d` on another, for
every value tried). Other keywords after a one-value `convergence=`, such as `restrict=`, were read correctly.
`iterations=250 convergence=1e-7` and `convergence=1e-7,1e-3 iterations=250` both work. Check the
`scf: conv = …; iter=…` echo line in the output.
```

**See also:** {ref}`iterations ($scf) <scf.iterations>`, {ref}`procedure ($scf) <scf.procedure>`

(scf.iterations)=
## `iterations`

```{index} single: iterations ($scf)
```

**Type:** list\
**Default:** `32,16`\
**Status:** current · verified on 25 (2025.02.28)\
**Sources:** input.txt; 01 §4.5; 04 #319; 05 §5; Dft.rtf; 02 §3.2 (pri help); 04 #306; 08 t01, t10, t28, t71b

Default: Version 25 echoes `iter=32,16` for DFT. v6, v13 and v15 echoed `16,16`, a HF run for CCSD showed `48,16`, and
`Dft.rtf` gives 30 (older version). The default may depend on the method and version.


Maximum number of iterations and of microiterations (`iterations=it,micro`).

```{note}
**An unconverged SCF does not stop the run.** Version 25 prints `no convergence!`, then still prints `E =`,
the orbitals and the properties, and exits with status 0. Search the output for `no convergence!`.

Raising the limit moderately is fine: an OH radical failed at the default 32 iterations and converged after
34 with `iterations=100`. A very large limit does not replace understanding why the SCF is not converging
(`Dft.rtf` warns against it). A recommended technique for difficult cases is to cap the run at
`iterations=10`, save the vectors (`$control save=`) and restart with `$guess read=1`, repeating as needed.
```

**See also:** {ref}`convergence ($scf) <scf.convergence>`, {ref}`read ($guess) <guess.read>`

(scf.procedure)=
## `procedure`

```{index} single: procedure ($scf)
```

**Type:** enum\
**Default:** `nr`\
**Status:** current · verified on 25 (2025.02.28)\
**Sources:** input.txt; Dft.rtf; 04 #320; 08 t07b

Default: `nr` for GGA DFT.

Algorithm for solving the SCF equations. If one procedure fails, try the other.

```{tabularcolumns} \Y{0.3}\Y{0.7}
```

| Value | Meaning |
|---|---|
| `nr` | Newton–Raphson quadratically convergent. Can recover even from a wrong starting electronic configuration but may blow up in hard cases. (**default**) |
| `bfgs` | BFGS Hessian update. Less prone to blowing up but usually slower and sometimes converges poorly. |

**Example:**

```text
$scf convergence=1e-7 procedure=bfgs iterations=250 $end
$grid accuracy=1e-9 $end
```

(scf.d1small)=
## `d1small`

```{index} single: d1small ($scf)
```

**Type:** switch\
**Default:** `0`\
**Status:** current · not verified\
**Sources:** input.txt

Small-component density in quadratically convergent SCF.

```{tabularcolumns} \Y{0.3}\Y{0.7}
```

| Value | Meaning |
|---|---|
| `1` | Include the small-component density in the linear equations of quadratically convergent SCF (scalar-relativistic pure DFT). |
| `0` | Discard these contributions. This is faster, but SCF may fail to converge for molecules containing the heaviest atoms. (**default**) |

**See also:** {ref}`four ($control) <control.four>`

(scf.core)=
## `core`

```{index} single: core ($scf)
```

**Type:** integer\
**Default:** *none stated*\
**Status:** current · not verified\
**Sources:** input.txt

Default: computed from the atom table; see `$atoms core`.

Number of core electrons for HF-based methods.

**See also:** {ref}`core ($atoms) <atoms.core>`
