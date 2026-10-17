<!-- Generated from keywords/control.yaml by docs/_ext/priroda_keywords.py. Do not edit. -->


(group.control)=
# `$control`

```{index} single: $control
```

Job type, level of theory, basis-set file, Hamiltonian and printing.

(control.task)=
## `task`

```{index} single: task ($control)
```

**Type:** enum\
**Default:** `gradient`\
**Status:** current · not verified\
**Sources:** input.txt; Dft.rtf (default gradient, check); 02 §3.2 (pri: default gradient); 03 §5; 04 #69-#73, #145, #478, #497; 01 §4.2

Job type.

```{tabularcolumns} \Y{0.3}\Y{0.7}
```

| Value | Meaning |
|---|---|
| `energy` | Energy at the given geometry. |
| `gradient` | Energy and nuclear gradient. Costs little more than the energy. (**default**) |
| `hessian` | Second derivatives (force constants) followed by vibrational analysis and thermochemistry. |
| `optimize` | Geometry optimization, including saddle points with `$optimize saddle=1`. |
| `optimize+hessian` | Optimization followed by a Hessian at the final geometry. The only combined task that works. Present in v2 and v9 and later, absent in v6. |
| `irc` | Intrinsic reaction coordinate. Needs a Hessian at the TS in the input (`$Energy`). |
| `scan` | Relaxed potential-energy-surface scan over the coordinates in `$optimize fix`. |
| `nmr` | NMR shielding tensors. Works only with `theory=dft`. |
| `dipole` | Numerical dipole polarizabilities and their derivatives with respect to nuclear coordinates (used for Raman intensities). |
| `check` | Process the geometry only. *(undocumented)* |
| `extremal` | Gradient-extremal path (v9 banner "Calculation of Gradient Extremal Path"); slow. *(undocumented)* |
| `transit` | Synchronous transit in internal coordinates. Needs two `$molecule` blocks (start and end). Reported working in v8. *(undocumented)* |
| `saddle` | Approximate saddle-point search from two `$molecule` blocks (start and end). *(undocumented)* |
| `path` | Minimum-energy-path optimization from two `$molecule` blocks (start and end). *(undocumented)* |
| `conical` | Conical intersection of states 0 and 1 (v9 banner). Untested. *(undocumented)* |
| `anharmonic` | Anharmonic corrections to vibrational energies; slow. *(undocumented)* |
| `opt_n1` | Optimizer for very large systems (used for 8060 atoms with `theory=qm_n2`). Pairs with `$optimize mod=1`. *(undocumented)* |
| `thermostat` | Molecular dynamics with a thermostat; see `$dynamic`. *(undocumented)* |
| `uniq` | Filter duplicate structures among several `$molecule` blocks; see `$uniq`. *(undocumented)* |

```{note}
Two `task=` lines do not chain jobs: only the first one runs. Apart from `optimize+hessian`, sequences such
as optimize→NMR need separate runs or an external driver script.
`task=critical` does not work; density critical points come from `print=+density`.
`task=QM` appears only in the header of the shipped `qm.in` parameter file and is not a user task.
The binary contains further task words (`IRC4`, `PATHX`, `PATHR`, `STERIC`, `POLARIZABILITY`, `MMDYNAMIC`,
and others) that are untested or need data that is not distributed.
```

**See also:** {ref}`saddle ($optimize) <optimize.saddle>`, {ref}`points ($optimize) <optimize.points>`, {ref}`print ($control) <control.print>`

(control.theory)=
## `theory`

```{index} single: theory ($control)
```

**Type:** enum\
**Default:** `dft`\
**Status:** current · not verified\
**Sources:** input.txt; Dft.rtf (default dft); 06 §3 (v5 ab initio list); 03 §5 (Evgeniy 2011 test); 04 #96, #99, #307-#310; 01 §3.1, §4.2

Theoretical method.

```{tabularcolumns} \Y{0.3}\Y{0.7}
```

| Value | Meaning |
|---|---|
| `dft` | GGA DFT with density fitting. Hybrid functionals are **not** applied here: see notes. (**default**) |
| `ridft` | Hybrid DFT with exact exchange via the resolution-of-identity (RI) approximation. Required for hybrid functionals. |
| `DFT_n4` | Newer DFT variant, used in the official example inputs with `func=LPBEVV` (2025). *(undocumented)* |
| `tddft` | GGA time-dependent DFT (no hybrid TDDFT). |
| `rimp2` | RI-MP2. |
| `hf` | Hartree–Fock. *(undocumented)* |
| `rihf` | RI Hartree–Fock. *(undocumented)* |
| `cis` | CIS (RHF/UHF). Slow and disk-hungry. *(undocumented)* |
| `mp2` | Conventional MP2 (RHF, UHF, ROHF). Very disk-hungry. *(undocumented)* |
| `mp3` | MP3. *(undocumented)* |
| `mp4dq` | MP4(DQ). *(undocumented)* |
| `mp4sdq` | MP4(SDQ). *(undocumented)* |
| `mp4sdtq` | MP4(SDTQ) (RHF). *(undocumented)* |
| `ccs` | CCS. *(undocumented)* |
| `ccd` | CCD. *(undocumented)* |
| `ccsd` | CCSD (RHF/UHF). |
| `ccsd4t` | CCSD(T). |
| `ccsdsd` | Linear-response (EOM) CCSD for excited states (RHF). *(undocumented)* |
| `qm_n3` | Laikov's semiempirical QM model. Needs `basis=qm.in`; parameters exist for H, Li–F, Na–Cl, Sc–Cu. *(undocumented)* |
| `qm_n2` | Earlier variant of the QM model, used for very large systems with `task=opt_n1`. *(undocumented)* |

```{note}
**Hybrid trap.** Hybrid functionals (`PBE1`, `B3LYP`, …) take effect only with `theory=ridft`. With `theory=dft`
or `tddft`, older versions silently drop the exact exchange and run a pure GGA. Newer ones abort with
`MPI_Abort` after reading the basis twice.

The ab initio list comes from the v6 documentation and a 2011 user test, which was energy-only. These
were reported **not** working in v6: `mp4`, `rimp4`, `rimp4sdtq`, `rimp4sdq`, `riccsd`, `riccsd4t`. They
either crash or return the HF energy. The binary contains many more method words (CASSCF, MRCISD,
CCSDT, …); none has been reported working.
```

**See also:** {ref}`functional ($dft) <dft.functional>`

(control.state)=
## `state`

```{index} single: state ($control)
```

**Type:** list\
**Default:** *none stated*\
**Status:** current · not verified\
**Sources:** input.txt

For excited-state methods. The first value is the excited state n whose properties are computed; the second
is the number of states N included in the iterative solution of the equations (`state=n,N`).

(control.basis)=
## `basis`

```{index} single: basis ($control)
```

**Type:** string\
**Default:** *none stated*\
**Status:** current · not verified\
**Sources:** input.txt; Dft.rtf; 01 §4.11, §6; 03 §5; 04 §0

Default: basis-set data are read from the input file itself.

Name of the file containing the basis-set data (and ECPs, or QM parameters for `qm.in`). The name may be
double-quoted, which is needed when the path contains special characters. Use straight quotes: typographic
quotes break parsing.

```{note}
Shipped files include `basis.in` (Λ/L family, default set `L1`), `basis4.in` (scalar-relativistic L family;
needs `four=1`), `3z.bas` (DFT only, Z ≤ 54), `sbk.bas` (SBK ECPs, up to Z = 86), `b2*.in`, `b2u*.in`,
`b4s*.in`, and `qm.in`. An absolute path is safest. Chapter "Basis sets" has the full family list.
```

**See also:** {ref}`set ($molecule) <molecule.set>`, {ref}`four ($control) <control.four>`

(control.four)=
## `four`

```{index} single: four ($control)
```

**Type:** switch\
**Default:** `0`\
**Status:** current · not verified\
**Sources:** input.txt; 01 §3.3; 04 #207-#208, #336

Four-component option.

```{tabularcolumns} \Y{0.3}\Y{0.7}
```

| Value | Meaning |
|---|---|
| `0` | Non-relativistic theory. (**default**) |
| `1` | Scalar-relativistic theory (K. G. Dyall, J. Chem. Phys. 100 (1994) 2118–2127). The output reports "Hamiltonian: scalar-relativistic". |

```{note}
Required with the relativistic basis file `basis4.in`. Forgetting it is a common cause of failed runs with that file.
```

**See also:** {ref}`nucleus ($control) <control.nucleus>`, {ref}`d1small ($scf) <scf.d1small>`

(control.nucleus)=
## `nucleus`

```{index} single: nucleus ($control)
```

**Type:** enum\
**Default:** *none stated*\
**Status:** current · not verified\
**Sources:** input.txt; 01 §4.2; 06 §1

Default: `finite` for four-component theory, `point` for non-relativistic theory.

Nuclear model. The official example inputs write it as `nuc=finite`.

```{tabularcolumns} \Y{0.3}\Y{0.7}
```

| Value | Meaning |
|---|---|
| `finite` | Gaussian nuclear model (L. Visscher, K. G. Dyall, At. Data Nucl. Data Tables 67 (1997) 207–224). |
| `point` | Point-nucleus model. |

```{note}
A basis optimized for a point nucleus must not be used with the finite-nucleus model, and vice versa.
```

**See also:** {ref}`four ($control) <control.four>`

(control.print)=
## `print`

```{index} single: print ($control)
```

**Type:** flags\
**Default:** *none stated*\
**Status:** current · not verified\
**Sources:** input.txt; Dft.rtf; 06 §3; 04 #376, #460, #498-#502, #509

Printing options. Flags are appended one after another; `+` switches an option on and `-` switches it off.
The leading `+` can be omitted (`print=charges+bonds`).

```{tabularcolumns} \Y{0.3}\Y{0.7}
```

| Value | Meaning |
|---|---|
| `+charges` | Hirshfeld charges (DFT methods), printed as "Atomic partitions of the density". |
| `+bonds` | Mulliken populations and bond orders (SCF only), printed as "Overlap populations". |
| `+esr` | ESR parameters. |
| `+vectors` | SCF vectors. |
| `+molden` | MOLDEN data: vibrations on `freq>` lines for `task=hessian`; with `+vectors+molden` also orbitals on `mos>` lines. |
| `+density` | Critical points of the electron density (QTAIM). Combine with `+charges` to label them. *(undocumented)* |
| `-internals` | Suppress the printout of internal coordinates. *(undocumented)* |

**Example:**

```text
$control print=+vectors+molden $end
```

(control.save)=
## `save`

```{index} single: save ($control)
```

**Type:** string\
**Default:** *none stated*\
**Status:** current · not verified\
**Sources:** input.txt; Dft.rtf; 04 #306

File name for saving SCF vectors. With `$guess read=1` the vectors are read back from the same file.
This is the basis of the SCF restart technique.

**See also:** {ref}`read ($guess) <guess.read>`
