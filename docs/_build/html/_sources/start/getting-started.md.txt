(start.getting-started)=
# Getting started

This chapter takes you through three things: a single-point energy of water, a geometry optimization of ammonia
followed by a Hessian that proves the structure is a minimum, and the parts of the output you need to read along the
way. It assumes that Priroda is installed and that you can start it from a shell. {doc}`running` covers that.

:::{warning}
**The example inputs in this chapter have not been run yet.** They are assembled from inputs published by the developer
and by experienced users, adapted to the current basis-set file `basis.in`. They follow the documented syntax, but
nobody has checked them against a current Priroda binary. The output excerpts, by contrast, are copied verbatim from
real outputs posted by users or shipped with the program. They come from various molecules and versions, so they
will not match your runs number for number.
:::

## Before you start

Four practical points save most first-time failures.

- **Plain text with Unix line endings.** Write inputs as plain ASCII with LF line endings and straight quotes. A file
  saved with Windows (CRLF) line endings gives errors such as `molecule input: ''` or `?rtesian`, or makes
  `task=scan` silently run an optimization. Convert such files with `dos2unix`.
  <!-- src: 04 §0 (CRLF symptoms) -->
- **Give the basis file by its full path.** The {ref}`basis <control.basis>` keyword names the basis-set file.
  Relative names have failed on Linux, and an absolute path is the safe choice. The examples below use
  `/home/user/priroda/basis.in`; replace it with the location of `basis.in` on your machine.
  <!-- src: 04 §0, #154 (full path to the basis file) -->
- **Atomic numbers are integers.** Each atom line in `$molecule` starts with the atomic number written as an integer
  (`8`, not `8.0` and not `O`). <!-- src: keywords/molecule.yaml body -->
- **Running.** A serial run is `p input output`; a parallel run on one node is `p -np 4 input output`.
  Use full paths here too. <!-- src: 04 §0 (running); 06 §7 -->

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
 z-matrix
 set=L1
   8
   1    1    0.96252725
   1    1    0.96252725    2    102.943872
$end
```
<!-- verify -->
<!-- src: geometry from input.txt ($molecule set= example, there with old sets B1/B2); $system values from 02 §4.1; basis.in + set=L1 from 01 §5.5, 04 #152 -->

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
  {ref}`multiplicity <molecule.mult>` (2S+1), the geometry as a Z-matrix (distances in Å, angles in degrees), and
  the basis set. {ref}`set=L1 <molecule.set>` picks the set named `L1` from `basis.in`. `L1` is also the default
  set of that file, and users compare it to cc-pVDZ in size. <!-- src: 01 §6.1, §6.2; 04 §0 (L1 ≈ cc-pVDZ) -->

:::{note}
Hybrid functionals such as `PBE1` or `B3LYP` need {ref}`theory=ridft <control.theory>`. With `theory=dft`, older
versions silently drop the exact exchange, and newer ones abort. See {ref}`$control theory <control.theory>`.
<!-- src: 04 §0, #96, #99, #307-#310 -->
:::

Run it:

```bash
p water.in water.out
```

### What to look for in the output

Near the top, a summary box repeats what the program understood from your input. It is the quickest check that the
charge, multiplicity, method and functional are what you meant. This box is from the C60 example on the official site:

```text
 +---------------------------------------
 | Number of atoms                     60
 | Charge of molecule                   0
 | Spin multiplicity                    1
 | Number of alpha electrons          180
 | Number of beta  electrons          180
 | Number of core  electrons           60
 | Theoretical Method                 DFT
 | Approximation to E(xc)             PBE
 | Dimension of wavefunction basis    840
 | Dimension of   auxiliary  basis   2400
 | Hamiltonian: non-relativistic
 +---------------------------------------
```
<!-- src: 01 §7 item 5 (C60.df.l.2.out, Priroda 13) -->

Next comes the SCF iteration table (columns for the energy, the energy change and the gradient). A successful SCF
ends with the line `converged!`. If you see `no convergence!` or `SCF is far from convergence`, the energy is not
usable; {ref}`troubleshooting.common-problems` lists the fixes.
<!-- src: 02 §3.3 (SCF markers); 01 §7 item 8 -->

The total energy follows, in hartree, on the line starting with `E  =`, together with its components. This excerpt
is from a user's output:

```text
  E  =    -232.0211375591
  T  =     230.89636282  V  =    -944.03076786  J  =     312.67315771
  Ex =     -33.07586264  Ec =      -1.37265420
```
<!-- src: 04 #375 (verbatim) -->

`E` is the number you want. The components `T`, `V`, `J`, `Ex` and `Ec` do not add up to `E`, because the nuclear
repulsion energy is not printed on these lines. This is expected and is not an error.
<!-- src: 04 #382 (Laikov, relayed) -->

Runs that compute a gradient also print the result as a restart block on lines prefixed with `eng>`, which starts
with `eng> E=`. Whether a pure `task=energy` run prints this block as well is not documented.
<!-- src: 01 §4.10, §7 item 8 --> <!-- verify: eng block for task=energy -->

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
<!-- verify -->
<!-- src: adapted from 06 §2 FAQ example 1 (there basis=basis1.bas, set=B11, $grid/$scf lines); basis.in + L1 from 01 §6 -->

The third hydrogen is placed by one distance and two angles: the negative index `-3` means "the angle to atom 3"
instead of a dihedral. <!-- src: 06 §2; keywords/molecule.yaml body (Z-matrix forms) -->

{ref}`tol <optimize.tolerance>` is the convergence threshold on the gradient. The displacement threshold is then set
to 100 times that value. The default is `1e-4`; the tighter `1e-5` used in most published examples is a better
starting point for a Hessian. {ref}`steps <optimize.steps>` caps the number of cycles (default 50). If an optimization
needs far more than 50 steps, raising the limit rarely helps; supplying a Hessian usually does.
<!-- src: 06 §3 $optimize; 01 §4.6 (tol echo); keywords/optimize.yaml steps notes -->

Run it with `p nh3.in nh3.out`.

### Step 2: check convergence

Each optimization cycle starts with a line such as `Geometry Optimization Step 0:`, and ends with the maximum
gradient (`G(max) = ...`) and displacement (`Max. Displacement = ...`). When both are below the thresholds, the program
prints `OPTIMIZATION CONVERGED in N steps!`. Check for it:
<!-- src: 03 §8 (step header); 06 §4 (G(max), Max. Displacement, marker) -->

```bash
grep "OPTIMIZATION CONVERGED" nh3.out
```

Right after the marker, the program prints the optimized geometry as a ready-made `$molecule` group, each line
prefixed with `MOL>`, followed by the final energy. This excerpt is from the KNC wiki (a relativistic NpO2²⁺ run):

```text
 Max. Displacement = 0.0000040
    
 OPTIMIZATION CONVERGED in 4 steps!
MOL>$molecule
MOL> charge=2 mult=2
MOL> cartesian
MOL> set=L2
MOL>  93     0.00000003  -0.00000001  -0.00000007
MOL>   8    -0.00000002   0.00000001   1.71247831
MOL>   8    -0.00000002   0.00000001  -1.71247823
MOL>$end
MOL> Energy = -28944.57077327 
```
<!-- src: 06 §4 (verbatim, [....skip....] lines removed) -->

If the input geometry was a Z-matrix, as in `nh3.in`, the `MOL>` block reproduces the Z-matrix with the optimized
values. <!-- src: 01 §7 item 9 -->

### Step 3: take the final geometry

Strip the `MOL>` prefix to get a group you can paste into the next input. The following commands copy `nh3.in` to
`nh3_freq.in`, switch the task to `hessian`, drop the old `$molecule` group and everything after it, and append the
optimized geometry:

```bash
sed -e 's/task=optimize/task=hessian/' -e '/\$molecule/,$d' nh3.in > nh3_freq.in
sed -n 's/^MOL>//p' nh3.out >> nh3_freq.in
```
<!-- verify -->
<!-- src: own one-liners modelled on the official gm script (01 §8); prefix-stripping idea from 06 §4 -->

The first command assumes that `$molecule` is the last group of the input, as in all examples here. The `Energy = ...`
line that ends up after `$end` does no harm: text outside a group is ignored. A normal optimization prints the `MOL>`
block only once. A scan or an IRC prints one per point, so there you would pick the block you need.
<!-- src: 01 §4 (text after $end ignored); 02 §3.3 (marker per point in scan/IRC) -->

:::{note}
**If the optimization did not converge**, there are no `MOL>` lines. Do not restart from the original geometry: start
from the last one reached. The KNC wiki did this with a local script, `lastgeo`, whose code was never published.
The limor1 scripts read the current geometry from lines prefixed with lower-case `mol>`, so this keeps the last such
block:

```bash
sed -n 's/^mol>//p' nh3.out | awk '/\$molecule/{buf=""} {buf=buf $0 "\n"} END{printf "%s", buf}'
```

Whether current versions print `mol>` lines at every step is not confirmed. The official `gm` script (below) falls
back to the input echo (lines starting with `<$molecule`) when there are no `MOL>` lines.
<!-- src: 06 §5 step 7, §6 (lastgeo unpublished; awk pattern); 02 §3.3 (mol = current $molecule); 01 §8 (gm fallback) -->
<!-- verify: mol lines in current output -->
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
<!-- verify -->
<!-- src: structure from 06 §5 steps 8-9; print=+molden from 06 §3, §9; $thermo sigma from input.txt, 03 §10 -->

The `$optimize` group is ignored by a Hessian run but does no harm, and it is useful again if you have to go back to
step 1. {ref}`sigma <thermo.sigma>` is the rotational symmetry number used in the thermochemistry; for ammonia
(point group C3v) it is 3. Whether Priroda can work it out itself is not documented, so set it. Temperatures go in
{ref}`temperature <thermo.temperature>`.
<!-- src: input.txt $thermo; 03 §10 (sigma works, = R ln σ correction to S) --> <!-- verify: automatic sigma -->

For DFT the Hessian is analytic; the output announces it with `ANALYTIC SECOND DERIVATIVES OF SCF ENERGY`.
<!-- src: 04 #460 --> <!-- verify: header text in current version -->

### Step 5: check the frequencies

The KNC wiki tells you to search for `Normal Mode`: the vibrational frequencies follow that line. For a minimum,
**all of them must be real (positive)**. A single imaginary frequency marks a transition state; several mean a
higher-order saddle point.
<!-- src: 06 §5 steps 11-12, §8 -->

```bash
grep -A 20 "Normal Mode" nh3_freq.out
```
<!-- verify -->

No verbatim copy of this table has been found in the sources, so it is described here in words. In Priroda 4 and
later it is a table with `|`-separated columns headed `Mode`, `Freq.`, `Mass.` and `IR Int.` (mode number,
frequency in cm⁻¹, reduced mass, IR intensity), according to the parsing code of the limor1 scripts. Those scripts
recognize imaginary frequencies by an `i` attached to the value. Check how your version prints them before relying
on either.
<!-- src: 02 §3.3, §5.6 (table header from pri2mol/priIR) --> <!-- verify: whole table format, imaginary notation, units -->

### Step 6: if a frequency is imaginary, re-optimize

Put the Hessian you just computed into the optimization input. It is printed as a `$Energy` group on `eng>` lines.
Starting from a good Hessian, the optimizer can move off the saddle point; one extra cycle is usually enough.
<!-- src: 06 §5 step 13; 03 §8 (ClAlMe2 case, verification workflow) -->

```bash
sed -e 's/task=hessian/task=optimize/' nh3_freq.in > nh3_opt2.in
sed -n 's/^eng>//p' nh3_freq.out | awk '/\$Energy/{buf=""} {buf=buf $0 "\n"} END{printf "%s", buf}' >> nh3_opt2.in
```
<!-- verify -->
<!-- src: awk last-block pattern from 06 §6 (reconstruction of lasteng); 03 §14 (paste $Energy after $molecule's $end) -->

The second command appends only the last `$Energy` group, after `$molecule`. Do not leave an older `$Energy` group in
the file. Then run `nh3_opt2.in` and go back to step 2. (`ge nh3_freq` does the appending in place, if you work with
the official scripts.)

### Step 7: read the thermochemistry

Once all frequencies are real, the end of the Hessian output holds the zero-point energy and a table of thermodynamic
functions. The KNC wiki points to the string `ZPVE`. This is a user's verbatim output (molecule not stated):
<!-- src: 06 §5 step 14 -->

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

The temperature is printed in the `T =` line. Outputs posted by users show both `298.000 K` and `298.150 K`, so check
which value your version uses and set {ref}`temperature <thermo.temperature>` explicitly if it matters.
<!-- src: 04 #80, #476 (298.000), #224 (298.150); keywords/thermo.yaml (298.15 per Dft.rtf) --> <!-- verify -->

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
<!-- verify -->
<!-- src: 04 #73, #478 (Metalian); keywords/control.yaml task values -->

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
| `Normal Mode` | the start of the frequency table |
| `ZPVE`, `T = ... K` | zero-point energy and the thermochemistry table |
| `Overlap populations:` | Mulliken populations (`print=+bonds`) |
| `Atomic partitions of the density:` | Hirshfeld charges (`print=+charges`) |
| `freq>` | vibrations in Molden format (`print=+molden`, Hessian runs) |
| `mos>` | orbitals in Molden format (`print=+vectors+molden`) |

<!-- src: 01 §7; 02 §3.3; 06 §4, §8; 03 §14; 04 #79 -->

(qs-charges)=
### Charges and bond orders

With `print=+charges`, DFT runs print Hirshfeld charges in a block headed `Atomic partitions of the density:`. With
`print=+bonds`, SCF runs print Mulliken populations and bond orders in a block headed `Overlap populations:`. The
flags can be combined, as in `water.in`. The column layout of these blocks is not shown in the sources; for open-shell
molecules the same tables are thought to carry spin populations.
<!-- src: keywords/control.yaml print; 06 §3, §8; 04 #79 (header names) --> <!-- verify: block layout, spin columns -->

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

The `+molden` part is essential: without it, there are no `mos>` lines. The files are large, and Molden can be slow
with them. <!-- src: 03 §14 (one-liner, verbatim); 04 #508-#510 -->

**Geometry.** If the optimized geometry is Cartesian, this one-liner turns the `MOL>` block into an XYZ file that
Molden reads (the symbol list covers H to Ar; extend it for heavier elements):

```bash
sed -n 's/^MOL>//p' job.out | awk 'BEGIN{split("H He Li Be B C N O F Ne Na Mg Al Si P S Cl Ar",s," ")}
  NF==4 && $1+0>0 {n++; l[n]=s[$1]" "$2" "$3" "$4}
  END{print n; print "optimized geometry"; for(i=1;i<=n;i++) print l[i]}' > job.xyz
```
<!-- verify -->
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
