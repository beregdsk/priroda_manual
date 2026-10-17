(start.getting-started)=
# Getting started

This chapter takes you through three things: a single-point energy of water, a geometry optimization of ammonia
followed by a Hessian that proves the structure is a minimum, and the parts of the output you need to read along the
way. To download the program, see {ref}`obtaining-priroda`; for the examples you need one Linux executable (for
example `p`) and `basis.in`. {doc}`running` covers running the program in more detail.

The example inputs were run on Priroda 25 (2025.02.28), and most output excerpts are copied from those runs. A few
excerpts come from outputs posted by users of older versions; the text says so where it matters.
<!-- src: 08 -->

## Before you start

Four practical points save most first-time failures.

- **Plain text with Unix line endings.** Write inputs as plain ASCII with LF line endings and straight quotes. A file
  saved with Windows (CRLF) line endings gives errors such as `molecule input: ''` or `?rtesian`, or makes
  `task=scan` silently run an optimization. Convert such files with `dos2unix`.
  <!-- src: 04 §0 (CRLF symptoms) -->
- **Give the basis file by its full path.** The {ref}`basis <control.basis>` keyword names the basis-set file.
  A relative name works in version 25 when the file is in the directory you run from, but relative names have
  failed in older versions and in parallel runs, so an absolute path is the safe choice. The examples below use
  `/home/user/priroda/basis.in`; replace it with the location of `basis.in` on your machine.
  <!-- src: 04 §0, #154 (full path to the basis file); 08 t03 -->
- **Atomic numbers are integers.** Each atom line in `$molecule` starts with the atomic number written as an integer
  (`8`, not `8.0` and not `O`). A real number such as `8.0` gives no error: the program silently reads a different
  molecule. <!-- src: keywords/molecule.yaml body; 08 t09 -->
- **Running.** A serial run is `p input output`. Parallel runs are described in {doc}`running`.
  <!-- src: 04 §0 (running); 06 §7; 08 t01 -->

## A single-point energy

### The input

Save the following as `water.in`:

```text
$system mem=128 disk=1 $end
$control
 task=energy
 theory=dft
 basis=/home/user/priroda/basis.in
 print=+charges+bonds
$end
$dft functional=PBE $end
$molecule
 charge=0 mult=1
 cartesian
 set=L1
  8    0.000000    0.000000    0.117300
  1    0.000000    0.757200   -0.469200
  1    0.000000   -0.757200   -0.469200
$end
```
<!-- src: tests/inputs/t01_energy.in, run on version 25 (08 t01); $system values from 02 §4.1; basis.in + set=L1 from 01 §5.5, 04 #152 -->

Group by group:

- {ref}`$system <group.system>` sets the memory limit in MB and the scratch space. Here `disk=1` means 1 GB of disk
  for temporary files; a negative value would mean a RAM disk of that many MB. These values are per process.
  <!-- src: keywords/system.yaml -->
- {ref}`$control <group.control>` sets the job type and the method. {ref}`task=energy <control.task>` asks for the
  energy at the given geometry. {ref}`theory=dft <control.theory>` is GGA DFT with density fitting, the program's
  standard method. `print=+charges+bonds` adds Hirshfeld charges and Mulliken populations to the output (see
  [](#qs-charges) below).
- {ref}`$dft <group.dft>` selects the {ref}`functional <dft.functional>`. PBE is already the default, so this line
  only makes the choice visible. <!-- src: 01 §4.3 (default PBE) -->
- {ref}`$molecule <group.molecule>` holds the {ref}`charge <molecule.charge>`, the
  {ref}`multiplicity <molecule.mult>` (2S+1), the geometry, and the basis set. The geometry is given in Cartesian coordinates (Å), one line per atom: atomic number, then x, y,
  z. {ref}`set=L1 <molecule.set>` picks the set named `L1` from `basis.in`. `L1` is also the default
  set of that file, and users compare it to cc-pVDZ in size. <!-- src: 01 §6.1, §6.2; 04 §0 (L1 ≈ cc-pVDZ) -->

:::{note}
Hybrid functionals such as `PBE1` or `B3LYP` need {ref}`theory=ridft <control.theory>`. With `theory=dft`, older
versions silently drop the exact exchange, and newer ones abort with no error message. With `theory=tddft`,
version 25 still silently drops it. See {ref}`$control theory <control.theory>`.
<!-- src: 04 §0, #96, #99, #307-#310; 08 t08, t46 -->
:::

Run it:

```bash
p water.in water.out
```

### What to look for in the output

The excerpts below are from this input run on Priroda 25. The output starts with the version banner,
`Priroda 25 (2025.02.28)`, and the memory and disk limits. The line `molecule input: ''` follows in every run; it is
not an error. Then come the coordinates, the `formula:` line and a table of interatomic distances. Check the
formula: it is the quickest way to catch a misread `$molecule` group.
<!-- src: 08 t01, t09 -->

Next, a summary box repeats what the program understood from your input. Check that the charge, multiplicity,
method and functional are what you meant:

```text
 +---------------------------------------
 | Number of atoms                      3
 | Charge of molecule                   0
 | Spin multiplicity                    1
 | Number of alpha electrons            5
 | Number of beta  electrons            5
 | Number of core  electrons            1
 | Theoretical Method                 DFT
 | Approximation to E(xc)             PBE
 | Dimension of wavefunction basis     24
 | Dimension of   auxiliary  basis     50
 | Hamiltonian: non-relativistic
 +---------------------------------------
```
<!-- src: 08 t01 (verbatim) -->

The electron counts are per spin. "Number of core electrons" counts core orbitals (here the oxygen 1s); it matters
only for correlated methods.
<!-- src: 08 t01, t16 (inferred from the counts) -->

Two lines then echo the SCF and grid settings, including defaults you did not set:

```text
 scf: conv = 1.0e-06, 1.0e-03; iter=32,16; xmax = 0.25000; 0s; n1=12
 grid: accuracy=1.0e-08,1.0e-05, cut=1.0e-10,1.0e-07, t=-1
```
<!-- src: 08 t01 (verbatim, two non-adjacent lines) -->

Next comes the SCF iteration table (columns for the energy, the energy change and the gradient, with indented
micro-iterations). The grid is enlarged partway through, which is why the energy jumps once. A successful SCF ends
with the line `converged!`.
<!-- src: 08 t01; 02 §3.3 (SCF markers) -->

:::{warning}
If the SCF fails, the program prints `no convergence!` (or, in older versions, `SCF is far from convergence`) and
then **carries on**: it prints an energy, orbitals and properties, and exits normally. The numbers are not usable.
Always look for `converged!` before trusting a result; {ref}`troubleshooting.common-problems` lists the fixes.
:::
<!-- src: 08 t10 (no convergence, exit status 0); 01 §7 item 8 -->

The total energy follows, in hartree, on the line starting with `E  =`, together with its components:

```text
  E  =     -76.3653913723
  T  =      76.07611549  V  =    -199.28820003  J  =      46.93680394
  Ex =      -8.95038631  Ec =      -0.32925888

  dipole =   0.735449 au (  1.869339 D)
```
<!-- src: 08 t01 (verbatim) -->

If your energy differs from this one in more than the last few digits, check the basis file and the version.

`E` is the number you want. The components `T`, `V`, `J`, `Ex` and `Ec` do not add up to `E`, because the nuclear
repulsion energy is not printed on these lines. This is expected and is not an error.
<!-- src: 04 #382 (Laikov, relayed) -->

Every run also prints its results as a restart block on lines prefixed with `eng>`. For `task=energy` it holds the
energy and the dipole moment; gradient and Hessian runs add more:

```text
eng>$Energy
eng> E=-7.6365391372338e+01
eng> D=-2.96281302e-14  6.81315681e-13 -7.35448725e-01
eng>$end
```
<!-- src: 08 t01 (verbatim); 01 §4.10 -->

## Optimizing a geometry and confirming a minimum

The standard beginner procedure, as taught on the KNC wiki, alternates between optimizations and Hessians:
<!-- src: 06 §5 (KNC FAQ section 2) -->

1. Optimize the geometry.
2. Check that the optimization converged. If it did not, restart from the last geometry.
3. Take the final geometry and compute a Hessian (force constants and vibrational frequencies) there.
4. If any frequency is imaginary, the structure is not a minimum: re-optimize with that Hessian in the input, then
   compute a new Hessian.
5. When all frequencies are real, read the thermochemistry.

The Hessian check matters most when the start geometry is symmetric. An experienced user reports that Priroda's
optimizer rarely leaves imaginary frequencies, except when the starting structure is symmetric and the optimizer keeps
that symmetry; then the check is compulsory. <!-- src: 03 §8 (amg, Nov 2011) -->

### Step 1: optimize

Save the following as `nh3.in`:

```text
$system mem=128 disk=1 $end
$control
 task=optimize
 theory=dft
 basis=/home/user/priroda/basis.in
$end
$optimize tol=1e-5 steps=100 $end
$molecule
 charge=0 mult=1
 z-matrix
 set=L1
   7
   1    1    1.02672223
   1    1    1.02672140    2    104.150240
   1    1    1.02671372    2    104.144601   -3    104.150290
$end
```
<!-- src: adapted from 06 §2 FAQ example 1 (there basis=basis1.bas, set=B11, $grid/$scf lines); basis.in + L1 from 01 §6; run on version 25 as 08 t11 -->

The third hydrogen is placed by one distance and two angles: the negative index `-3` means "the angle to atom 3"
instead of a dihedral. <!-- src: 06 §2; keywords/molecule.yaml body (Z-matrix forms) -->

{ref}`tol <optimize.tolerance>` is the convergence threshold on the gradient. The displacement threshold is then set
to 100 times that value. The default is `1e-4`; the tighter `1e-5` used in most published examples is a better
starting point for a Hessian. {ref}`steps <optimize.steps>` caps the number of cycles (128 by default in version 25;
older versions used 50). If an optimization needs far more than 50 steps, raising the limit rarely helps; supplying a
Hessian usually does. The output echoes all these settings under `Geometry optimization options:`.
<!-- src: 06 §3 $optimize; 01 §4.6 (tol echo); keywords/optimize.yaml steps notes; 08 t11, t14 -->

Run it with `p nh3.in nh3.out`.

### Step 2: check convergence

Each optimization cycle starts with a line such as `Geometry Optimization Step 1:`, followed by the energy, the
largest gradient and the largest displacement. When both are below the thresholds, the program prints
`OPTIMIZATION CONVERGED in N steps!`. Check for it:
<!-- src: 03 §8 (step header); 06 §4 (marker); 08 t11 -->

```bash
grep "OPTIMIZATION CONVERGED" nh3.out
```

Right after the marker, the program prints the optimized geometry as a ready-made `$molecule` group, each line
prefixed with `MOL>`, followed by the final energy. For `nh3.in`, version 25 printed:

```text
 OPTIMIZATION CONVERGED in 6 steps!
MOL>$molecule
MOL> z-matrix
MOL> set=L1
MOL>   7
MOL>   1    1    1.02753254
MOL>   1    1    1.02744669    2    104.120811
MOL>   1    1    1.02748748    2    104.112983   -3    104.135802
MOL>$end
MOL> Energy =    -56.4988651558
```
<!-- src: 08 t11 (verbatim) -->

The block keeps the coordinate type of the input: a Z-matrix input gives a Z-matrix with the optimized values. Only
a charge or multiplicity that differs from the defaults (0 and 1) is written: `nh3.in` gives no such line, and an
OH⁻ optimization gave `MOL> charge=-1`. So the block can be pasted into the next input as it is.
<!-- src: 01 §7 item 9; 08 t11, t29; 06 §4 (NpO2 example: charge=2 mult=2) -->

### Step 3: take the final geometry

Strip the `MOL>` prefix to get a group you can paste into the next input. The following commands copy `nh3.in` to
`nh3_freq.in`, switch the task to `hessian`, drop the old `$molecule` group and everything after it, and append the
optimized geometry:

```bash
sed -e 's/task=optimize/task=hessian/' -e '/\$molecule/,$d' nh3.in > nh3_freq.in
sed -n 's/^MOL>//p' nh3.out >> nh3_freq.in
```
<!-- src: own one-liners modelled on the official gm script (01 §8); prefix-stripping idea from 06 §4; checked on the 08 t11 output -->

The first command assumes that `$molecule` is the last group of the input, as in all examples here. The `Energy = ...`
line that ends up after `$end` does no harm: text outside a group is ignored. A normal optimization prints the `MOL>`
block only once. A scan or an IRC prints one per point, so there you would pick the block you need.
<!-- src: 01 §4 (text after $end ignored); 02 §3.3 (marker per point in scan/IRC) -->

:::{note}
**If the optimization did not converge**, there are no `MOL>` lines, and the program prints no message about it:
the output just ends after the last step. Do not restart from the original geometry: start from the last one
reached. Every step prints the geometry for the next step as a `$molecule` group on lines prefixed with lower-case
`mol>`, so this keeps the last such block:

```bash
sed -n 's/^mol>//p' nh3.out | awk '/\$molecule/{buf=""} {buf=buf $0 "\n"} END{printf "%s", buf}'
```

The official `gm` script (below) falls back to the input echo (lines starting with `<$molecule`) when there are no
`MOL>` lines.
<!-- src: 06 §5 step 7, §6 (awk pattern); 02 §3.3; 01 §8 (gm fallback); 08 t11, t12 (mol lines every step, no message at the step limit; recipe checked on t12) -->
:::

#### The official helper scripts `ge` and `gm`

The download site ships two small bash scripts for exactly this loop. Both take a job name (with or without the `.in`
or `.out` extension) and work on `name.in` and `name.out` in place:
<!-- src: 01 §8 -->

- `gm nh3` replaces the `$molecule` group in `nh3.in` with the optimized one from `nh3.out` and keeps the old input as
  `nh3.bak`. Like the commands above, it requires `$molecule` to be the last group, because it replaces everything from
  `$molecule` onwards. It also appends the final `Energy =` line and, when non-zero, the dipole line.
- `ge nh3` appends the `eng>` lines of `nh3.out` (the `$Energy` group: energy, gradient and, after a Hessian run, the
  Hessian) to the end of `nh3.in`.

So a cycle with these scripts is: run, `gm`, edit the task, run again. Note that `ge` copies every `eng>` line in the
output, so use it on a Hessian output, not on an optimization output that has one block per step.
<!-- src: 01 §8 (ge sed copies all eng lines; one eng block per optimization step per 01 §7 item 8) -->

### Step 4: compute the Hessian

After step 3, `nh3_freq.in` looks like this, with your optimized values in place of these coordinates. Two optional
lines are added here: `print=+molden` (for viewing the vibrations, see [](#qs-molden)) and a `$thermo` group:

```text
$system mem=128 disk=1 $end
$control
 task=hessian
 theory=dft
 basis=/home/user/priroda/basis.in
 print=+molden
$end
$optimize tol=1e-5 steps=100 $end
$thermo sigma=3 $end
$molecule
 charge=0 mult=1
 z-matrix
 set=L1
   7
   1    1    1.02672223
   1    1    1.02672140    2    104.150240
   1    1    1.02671372    2    104.144601   -3    104.150290
$end
```
<!-- src: structure from 06 §5 steps 8-9; print=+molden from 06 §3, §9; $thermo sigma from input.txt, 03 §10; the same input without $thermo and $optimize ran on version 25 as 08 t13 -->

The `$optimize` group is ignored by a Hessian run but does no harm, and it is useful again if you have to go back to
step 1. {ref}`sigma <thermo.sigma>` is the rotational symmetry number used in the thermochemistry; for ammonia
(point group C3v) it is 3. **Priroda does not work it out itself**: without `sigma=` it uses 1, and the entropy comes
out too large by R ln σ (2.18 cal/(mol·K) for ammonia). The default temperature is 298.15 K; other temperatures go in
{ref}`temperature <thermo.temperature>`.
<!-- src: input.txt $thermo; 03 §10 (sigma = R ln σ correction to S); 08 t13 (no sigma detected, T = 298.150 K), t44 (sigma=3 lowers S by R ln 3) -->

For DFT the Hessian is analytic; the output announces it with `ANALYTIC SECOND DERIVATIVES OF SCF ENERGY`.
<!-- src: 04 #460; 08 t13 -->

### Step 5: check the frequencies

For a minimum, **all frequencies must be real (positive)**. A single imaginary frequency marks a transition state;
several mean a higher-order saddle point. The frequencies are in the table after the line `Harmonic Frequencies`.
For ammonia, version 25 printed:
<!-- src: 06 §5 steps 11-12, §8; 08 t13 -->

```text
 *------*---------*--------*---------*---------*--------*-----------*-----------*
 | Mode | Freq.   | Mass.  | IR Int. |Raman A. |Raman D.| ROA (90)  | ROA (180) |
 *------*---------*--------*---------*---------*--------*-----------*-----------*
 |    1 | 1095.36 |   1.18 | 111.670 |   0.000 | 0.0000 |   0.00000 |   0.00000 |
 |    2 | 1635.36 |   1.06 |  12.058 |   0.000 | 0.0000 |   0.00000 |   0.00000 |
 |    3 | 1635.49 |   1.06 |  12.054 |   0.000 | 0.0000 |   0.00000 |   0.00000 |
 |    4 | 3371.36 |   1.03 |   3.443 |   0.000 | 0.0000 |   0.00000 |   0.00000 |
 |    5 | 3488.82 |   1.09 |   0.493 |   0.000 | 0.0000 |   0.00000 |   0.00000 |
 |    6 | 3488.95 |   1.09 |   0.494 |   0.000 | 0.0000 |   0.00000 |   0.00000 |
 *------*---------*--------*---------*---------*--------*-----------*-----------*
```
<!-- src: 08 t13 (verbatim) -->

The columns are the frequency in cm⁻¹, the reduced mass in amu and the IR intensity in km/mol. The Raman columns
stay zero in a plain Hessian run; for Raman intensities, run `task=dipole` first and append its `num>` lines (see
{doc}`input-syntax`). A second table, `Normal Modes
(mass-weighted) and Frequencies`, follows with the mode vectors. To print the table:
<!-- src: 08 t13, t56; keywords/control.yaml (task=dipole for Raman) -->

```bash
grep -A 12 "Harmonic Frequencies" nh3_freq.out
```
<!-- src: 08 t13 (checked) -->

An imaginary frequency is printed with a trailing `i`. Planar ammonia, the transition state of the inversion,
gives one:

```text
 |    1 |  845.22i|   1.21 | 357.748 |   0.000 | 0.0000 |   0.00000 |   0.00000 |
```
<!-- src: 08 t24 (verbatim); 02 §3.3, §5.6 (limor1 scripts look for the i) -->

`grep "i|" nh3_freq.out` therefore finds the imaginary modes.

### Step 6: if a frequency is imaginary, re-optimize

Put the Hessian you just computed into the optimization input. It is printed as a `$Energy` group on `eng>` lines.
Starting from a good Hessian, the optimizer can move off the saddle point. In a version 25 test that started
exactly on a saddle point (planar ammonia), it reached the pyramidal minimum in 19 steps; from a near-symmetric
structure it usually takes fewer.
<!-- src: 06 §5 step 13; 03 §8 (ClAlMe2 case, verification workflow); 08 t43 -->

```bash
sed -e 's/task=hessian/task=optimize/' nh3_freq.in > nh3_opt2.in
sed -n 's/^eng>//p' nh3_freq.out | awk '/\$Energy/{buf=""} {buf=buf $0 "\n"} END{printf "%s", buf}' >> nh3_opt2.in
```
<!-- src: checked on the 08 t13 output: the appended group holds E, D, A, G, Dx and the packed Hessian H; 08 t25 (an appended Hessian is read), t43 (minimization from the saddle) -->
<!-- src: awk last-block pattern from 06 §6 (reconstruction of lasteng); 03 §14 (paste $Energy after $molecule's $end) -->

The second command appends only the last `$Energy` group, after `$molecule`. Do not leave an older `$Energy` group in
the file. Then run `nh3_opt2.in` and go back to step 2. (`ge nh3_freq` does the appending in place, if you work with
the official scripts.)

### Step 7: read the thermochemistry

Once all frequencies are real, the end of the Hessian output holds the zero-point energy and a table of thermodynamic
functions. The KNC wiki points to the string `ZPVE`. Version 25 prints the table at 298.150 K by default; this
older user output (molecule not stated) shows 298.000 K:
<!-- src: 06 §5 step 14; 08 t13 -->

```text
 E =  -196.328936    E0 =  -196.191669

 ZPVE = 0.137267 a.u. =   86.1366 kcal/mol

 ----------------------------------------------------------------------
 T =  298.000 K      ln(Q)       S          U          H          G
                              cal/mol*K  kcal/mol   kcal/mol   kcal/mol
 ----------------------------------------------------------------------
 translational      16.9514    38.6542     0.8883     1.4805   -10.0385
 rotational         11.1465    25.1313     0.8883     0.8883    -6.6008
 vibrational         0.6842     4.7490    87.1466    87.1466    85.7314
 total              28.7821    68.5345    88.9232    89.5154    69.0921
 ----------------------------------------------------------------------
```
<!-- src: 04 #476 (amge, Dec 2021, verbatim) -->

How to read it:

- `E` is the electronic energy in hartree. `E0 = E + ZPVE` is the energy corrected for the zero-point vibrational
  energy (here −196.328936 + 0.137267 = −196.191669).
- The `U`, `H` and `G` columns are **thermal corrections** in kcal/mol, not total values. They already contain the
  ZPVE. The program does not print the total enthalpy or free energy; you add them yourself.
- Take the corrections from the `total` row and add them to **E, not E0**. Adding them to `E0` would count the
  zero-point energy twice:

  H = E + ddH,  G = E + ddG,  with ddH = `H` (total) and ddG = `G` (total).

- Convert units before adding: 1 hartree = 627.51 kcal/mol. For the table above,
  G = −196.328936 × 627.51 + 69.0921 = −123129.28 kcal/mol, or −196.328936 + 69.0921 / 627.51 = −196.218831 hartree.
- The entropy `S` (cal/(mol·K)) is taken from the `total` row as it stands.

<!-- src: 04 #44, #134/#135 (H=E+ddH, G=E+ddG; use E not E0), #224/#225 (E0 = E + ZPVE), #474 (627.51), #476 (worked G) -->

:::{warning}
For a **single atom**, the table is wrong: the rotational row contains `-inf`/`inf` or a spurious RT term. Use only
the translational contribution for atoms. Older versions were also reported to put an extra RT into the enthalpy of
monoatomic species. <!-- src: 03 §10 (monoatomic -inf table, extra RT); 04 #80 -->
:::

The temperature is printed in the `T =` line. Version 25 uses 298.150 K; outputs posted by users of older versions
also show `298.000 K`. Set {ref}`temperature <thermo.temperature>` explicitly when you compare results across versions.
<!-- src: 04 #80, #476 (298.000), #224 (298.150); 08 t13 (298.150 in v25) -->

### The one-run alternative: `task=optimize+hessian`

You can let one job optimize the structure and then compute the Hessian at the converged geometry. In `nh3.in`,
change the task line:

```text
$control
 task=optimize+hessian
 theory=dft
 basis=/home/user/priroda/basis.in
 print=+molden
$end
```
<!-- src: 04 #73, #478 (Metalian); keywords/control.yaml task values; 08 t14 (optimize+hessian works in v25) -->

This is the only combined task that works: two `task=` lines do not chain jobs, and only the first one runs.
`optimize+hessian` existed in Priroda 2, was missing in versions 6 to 8, and is available again from version 9.
If the resulting Hessian shows an imaginary frequency, you still need step 6.
<!-- src: 04 §0 (only combined task; two task= lines); 03 §8 (version history) -->

(qs-reading-output)=
## Reading the output

### Where things are

The output is plain text, and the results meant for reuse are on lines tagged with a prefix, so `grep` finds them.
<!-- src: 06 §4 -->

| Look for | What it is |
|---|---|
| the summary box (`Number of atoms`, `Theoretical Method`, …) | what the program understood from the input |
| `converged!` / `no convergence!` | the end of each SCF |
| `E  =` | total energy in hartree, followed by its components (without nuclear repulsion) |
| `eng>` | the `$Energy` group: energy `E=`, dipole `D=`, gradient `G=`, and the Hessian after `task=hessian` |
| `OPTIMIZATION CONVERGED in N steps!` | a converged optimization |
| `MOL>` | the optimized geometry as a `$molecule` group, then `Energy =` |
| `Harmonic Frequencies` | the frequency table (`Normal Modes` follows with the mode vectors) |
| `ZPVE`, `T = ... K` | zero-point energy and the thermochemistry table |
| `Overlap populations:` | Mulliken populations (`print=+bonds`) |
| `Atomic partitions of the density:` | Hirshfeld charges (`print=+charges`) |
| `freq>` | vibrations in Molden format (`print=+molden`, Hessian runs) |
| `mos>` | orbitals in Molden format (`print=+vectors+molden`) |

<!-- src: 01 §7; 02 §3.3; 06 §4, §8; 03 §14; 04 #79 -->

(qs-charges)=
### Charges and bond orders

With `print=+bonds`, SCF runs print Mulliken charges and spin populations under `Overlap populations:`, followed by
a table of bond orders. With `print=+charges`, DFT runs print Hirshfeld charges and spins under
`Atomic partitions of the density:`. The flags can be combined, as in `water.in`, which gives:

```text
 Overlap populations:
  atom    charge   spin p.
 O1      -0.4167  -0.00000
 H1       0.2083  -0.00000
 H2       0.2083  -0.00000

   Bond orders:
  O1    |  H1   :  1.07  H2   :  1.07
  H1    |  O1   :  1.07
  H2    |  O1   :  1.07

 Atomic partitions of the density:
   atom    charge    spin
   1  O   -0.2905    0.0000
   2  H    0.1451    0.0000
   3  H    0.1451    0.0000
  total   10.0003    0.0000
```
<!-- src: keywords/control.yaml print; 06 §3, §8; 04 #79; 08 t01 (verbatim, timing line removed) -->

The `total` row of the Hirshfeld block sums the electron populations, not the charges.

(qs-molden)=
### Viewing results in Molden

The KNC wiki treats Molden as the reference viewer. Open files with the `READ` button in the `Miscellaneous` group.
<!-- src: 06 §9; 04 #26 -->

**Vibrations.** Run the Hessian with {ref}`print=+molden <control.print>` and cut out the `freq>` lines:

```bash
sed -n 's/^freq>//p' nh3_freq.out > nh3.freq
```

Open `nh3.freq` in Molden to animate the normal modes. <!-- src: 06 §9 (freq recipe, clean sed) --> <!-- verify -->

**Orbitals.** Add `print=+vectors+molden` to `$control`. The orbitals then appear on `mos>` lines:

```bash
grep '^mos>' water.out | sed 's/^mos>//' > water.mos
```
<!-- src: 08 t45 (recipe checked: gives [Molden Format], [Atoms] AU, [5D], [GTO], [MO]) -->

The `+molden` part is essential: without it, there are no `mos>` lines. The files are large, and Molden can be slow
with them. <!-- src: 03 §14 (one-liner, verbatim); 04 #508-#510 -->

**Geometry.** If the optimized geometry is Cartesian, this one-liner turns the `MOL>` block into an XYZ file that
Molden reads (the symbol list covers H to Ar; extend it for heavier elements):

```bash
sed -n 's/^MOL>//p' job.out | awk 'BEGIN{split("H He Li Be B C N O F Ne Na Mg Al Si P S Cl Ar",s," ")}
  NF==4 && $1+0>0 {n++; l[n]=s[$1]" "$2" "$3" "$4}
  END{print n; print "optimized geometry"; for(i=1;i<=n;i++) print l[i]}' > job.xyz
```
<!-- src: checked on Cartesian mol lines from 08 t12 -->
<!-- src: own one-liner replacing the KNC pri2xyz (06 §6, §9); MOL line layout from 06 §4, 01 §7 -->

For a Z-matrix geometry such as `nh3.in`, the `freq>` file from the Hessian run is the easier way to look at the
structure.

**pri2mol.** The Perl script `pri2mol` by the forum user amge, available from
`http://limor1.nioch.nsc.ru/quant/program/pri2mol/`, converts a Priroda output into Molden and XYZ files: geometries,
vibrations, orbitals, NMR shifts and density critical points. Priroda's own viewer, `xm`, is on the download site.
<!-- src: 04 §0, §14 (URL), #502, #508-#509; 02 §7.1; 01 §2.2 (xm) -->

## Where next

- {doc}`input-syntax` explains groups, keyword abbreviation, arrays and restart blocks.
- {doc}`running` covers memory, scratch disks and parallel runs.
- The {doc}`input reference <../reference/index>` describes every known keyword, group by group.
- {ref}`troubleshooting.common-problems` helps when a run fails.
