<!-- Generated from keywords/*.yaml by docs/_ext/priroda_keywords.py. Do not edit. -->

# Input reference

| Group | Purpose |
|---|---|
| {ref}`$system <group.system>` | Memory, disk and scratch-directory limits. |
| {ref}`$control <group.control>` | Job type, level of theory, basis-set file, Hamiltonian and printing. |
| {ref}`$molecule <group.molecule>` | Charge, multiplicity, geometry (Cartesian and/or Z-matrix) and per-atom basis sets. |
| {ref}`$guess <group.guess>` | Initial guess for the SCF vectors. |
| {ref}`$scf <group.scf>` | Spin restriction, convergence, iteration limits and SCF solver. |
| {ref}`$dft <group.dft>` | Exchange–correlation functional. |
| {ref}`$grid <group.grid>` | Adaptive integration grid for DFT. |
| {ref}`$integral <group.integral>` | Integral evaluation for RI methods. |
| {ref}`$atoms <group.atoms>` | Per-element core definitions for correlated (HF-based) methods. |
| {ref}`$optimize <group.optimize>` | Geometry optimization, saddle-point search, IRC and relaxed scans. |
| {ref}`$d2edr2 <group.d2edr2>` | Numerical Hessian by finite differences of the gradient. |
| {ref}`$thermo <group.thermo>` | Thermochemistry after a Hessian calculation. |
| {ref}`$nmr <group.nmr>` | Reference shieldings and extra points for NMR shielding calculations. |
| {ref}`$Energy <group.Energy>` | Results of an earlier run (energy, gradient, Hessian, dipole data), read back as input. |
| {ref}`$dynamic <group.dynamic>` | Molecular dynamics with a thermostat. |
| {ref}`$uniq <group.uniq>` | Duplicate-structure filtering over several `$molecule` blocks. |

```{toctree}
:hidden:

system
control
molecule
guess
scf
dft
grid
integral
atoms
optimize
d2edr2
thermo
nmr
Energy
dynamic
uniq
```
