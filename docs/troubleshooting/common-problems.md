(troubleshooting.common-problems)=
# Solving common problems

This chapter is arranged by symptom. Each entry names the likely cause and the fix that users have reported.

Almost everything here comes from user forums, not from the developer. Each fix says how well it is supported:
"confirmed by several users" means more than one person reported that the fix worked, and "single report" means one
user posted it and nobody confirmed it. Most reports date from Priroda 6 to 10 (about 2009–2015); a few are from 2008
or from 2016–2026. Where a problem may have been fixed in later builds, the entry says so.

:::{note}
Most fixes below have not been checked against a current Priroda binary. Where a test run on version 25
(2025.02.28) confirmed or contradicted a report, the entry says so.
:::

(troubleshooting.input)=
## The input is not read, or is read wrongly

When Priroda cannot parse the input it often stops early, with little or no explanation. Just as often a mistake is
silently ignored and the run goes on: in version 25 a group written as `&dft` was skipped, an unknown `theory` ran
Hartree–Fock, an unknown `task` only set up the job, keywords in a group the task does not read were not checked,
and atomic numbers written as `8.0` gave a wrong molecule (see below). Before anything else, open the output and check
what it echoed back: the `Memory:` and `Disk:` lines, the `formula:` line, the summary box (number of atoms, charge,
multiplicity, method, functional), the `scf:` line and the `grid:` line. If a value you set is not shown there,
Priroda did not read it.
<!-- src: 05 §5 (echo lines), 04 #319; 08 t01 (v25 echo lines); 08 t23, t50b, t50, t40c, t09 (silently ignored) -->

### Output stops after `molecule input: ''`

The line `molecule input: ''` itself is printed in every run. It is a problem only when the output ends there or
continues with garbled text.
<!-- src: 08 t01 -->

**Cause.** In almost every reported case the input file had Windows (CRLF) line endings. The tail of the output then
shows a mangled keyword followed by `?`, for example `' ?matrix`, `?rtesian` or `'z-matrix' ?`. Inputs saved as
Unicode, or edited in Word, were also reported not to be read. Word's "save as text" still writes CRLF line endings.
<!-- src: 04 #63-#65, #104, #113, #117; 03 §2 (Dimylko, amg) -->

**Fix.** Save the input as plain ASCII text with Unix (LF) line endings, for example with `dos2unix input.in`.
Notepad++ and Far Manager (Shift+F2 in the editor) can also convert line endings. Use straight quotes only. Several
users confirmed this fix. Running `dos2unix` on a file that already has LF endings does no harm.
<!-- src: 04 #64, #65 (confirmed), #174; 03 §2 -->

### The molecule is wrong: odd formula, extra atoms

Atomic numbers written as real numbers (`8.0` instead of `8`) in `$molecule`. The atom lines are read as a stream of
numbers, so everything after the first `.0` shifts. In version 25 there is **no error**: water written with `8.0` and
`1.0` ran as four atoms, an oxygen and three empty centres with Z=0, with the formula `__3O` and a meaningless
energy. An older version was reported to stop with `illegal charge/multiplicity` instead. Write atomic numbers as
integers, and check the `formula:` line and the atom count at the top of every output.
<!-- src: 03 §5 (Evgeniy, Aug 2011); 08 t09 -->

One experienced user also advises avoiding Cyrillic letters and spaces in the computer name, directory names and file
names. In the case where he gave this advice, fixing the line endings alone was reported to solve the problem.
<!-- src: 03 §2 (amg, Nov 2011; Dimylko resolved "after fixing line endings", 03 line 517) -->

### `task=scan` runs an optimization, or nothing works on one machine

An input that runs on one computer but not on another, or a `task=scan` that silently runs a plain optimization, has
been traced to the same encoding problem: an input edited in Word or saved as Unicode. Fix it as above.
<!-- src: 04 #110, #113 -->

Two `task=` lines in one input do not chain jobs: in a 2011 report (version 6) only the first one ran, and no error
was printed. The only combined task name is `task=optimize+hessian`; see {ref}`task <control.task>`. A user in 2011
added that even this one did not work in all versions. Run other sequences, such as optimization followed by NMR, as
separate jobs.
<!-- src: 04 #69, #70; 09 (optimize+hessian is the only combined task name in the v25 binary) --> <!-- verify -->

### The basis file is not found

- Quote file names with straight double quotes: `basis="3z.bas"`. Two single quotes (`basis=''3z.bas''`) give
  `error opening file ''3z.bas''`, and typographic quotes copied from a web page or word processor fail too.
  <!-- src: 03 §2 (denis, Evgeniy); 04 #64 -->
- Give an absolute path to the basis file if Priroda is not started from the directory that contains it. One user's
  parallel run aborted with `MPI_Abort` until he wrote the full basis path in the input. In version 25 a relative
  name worked with the file in the current directory, in a serial and in a 2-process run.
  <!-- src: 04 #152-#154; 08 t03, t59 -->
- The relativistic basis file `basis4.in` needs {ref}`four=1 <control.four>` in {ref}`$control <group.control>`.
  Without it the job stops right after the `Basis set input:` line, with `1?` as the only message (version 25).
  The user who first reported this confirmed the fix.
  <!-- src: 04 #206-#208; 08 t49 -->
- The name given in {ref}`set <molecule.set>` must exist in the basis file.
  <!-- src: 06 §10 -->

### The input or output file cannot be opened

On Linux the usual cause is a wrong path. Check it with `ls -l` before blaming Priroda. In one reported case the
directory in the command line simply did not exist. Work in a directory you own and can write to (for example
`~/priroda`), `cd` into it, and run the binary with an explicit path, since the current directory is normally not in
`PATH`:
<!-- src: 04 #153, #159-#171 -->

```text
cd ~/priroda
./p job.in job.out
```

File names are case-sensitive, unlike keywords. One user of an older version saw the extra complaint
`0: output file 'tasK.out'?` when the file name contained capital letters. Version 25 wrote an output file with
capital letters in its name without complaint.
<!-- src: 04 #161; 06 §10 (case-sensitive names); 08 t19 -->

On Windows, `cd` into the folder with the input before running `p.exe input.in output.out`. One user still got
`cannot open input file` after doing that, and the thread never found the cause.
<!-- src: 04 #130-#133 -->

### Output stops at `0: opening file /tmp/...` (Windows)

Old Windows builds put scratch files in `/tmp` when nothing else is set (the output echoes `Disk:   1 GB '/tmp'`),
and Windows has no `/tmp`. The Linux version 25 has the same default and also honours `TMPDIR`. Set the scratch
directory explicitly, for example `$system path=. $end`, or set the `TMPDIR` environment variable before starting the
program. This is the oldest known problem in both forums and the fix is well established. See {ref}`path <system.path>`.
<!-- src: 03 §2 (#0, GemmaNC 2009); 04 #20, #21, #128; 08 t64a, t64b -->

### `$scf` settings are ignored or rejected

The parser has a problem when {ref}`convergence <scf.convergence>` is directly followed by another keyword in
{ref}`$scf <group.scf>`. In version 25,

```text
$scf convergence=1e-7 iterations=250 $end
```

stops the run after the basis-set echo with `*** error in '$scf' : unknown name terations`. The message names
`iterations` with its first letters missing. How many are missing depended on the machine, not on the value: the same
input printed `unknown name erations` with the `p4_d` executable on another computer, for every value tried, as
forum users of 2015 builds also reported. With
{ref}`procedure=bfgs <scf.procedure>` between them, `$scf convergence=1e-7 procedure=bfgs iterations=250 $end`, both
values are read; one forum user found that the pair worked only with `procedure=bfgs`.
<!-- src: 05 §5.1 (EvgeniX, amge 2015); 04 #322-#324; 08 t07a, t07b; 08 review check (convergence value series); 08 Slurm tests (first attempt, s02) -->

Further tests on version 25 narrowed it down. The problem is a `convergence=` with **one** value followed by
`iterations=`, also on the next line; other keywords after it, such as `restrict=` or `procedure=`, were read
correctly. Both of these work:

```text
$scf convergence=1e-7,1e-3 iterations=250 $end
$scf iterations=250 convergence=1e-7 $end
```

So give `iterations` before `convergence`, or give `convergence` two values, and confirm the values in the `scf:` echo line of the output, for
example `scf: conv = 1.0e-07, 1.0e-03; iter=250,16`.
<!-- src: 08 t22a, t22b, t22c -->

(troubleshooting.scf)=
## SCF does not converge or diverges

### Recognizing the problem

Users report that Priroda's SCF usually converges well, better than in many other programs. Trouble mostly comes
with metals in low oxidation states, where the electronic structure has some multiconfigurational character, with
very large basis sets, and with diffuse functions.
<!-- src: 04 #194 (EvgeniX); 04 #320 (diffuse) -->

Signs of trouble in the SCF table:

- `hmin` values that keep growing in magnitude, or a line such as `h = -25.15!`;
- `lowest eigenvalue = ...!!!` lines with large negative numbers;
- an energy that rises from one macro-iteration to the next;
- `no convergence!`, in older versions followed by `SCF is far from convergence`.
<!-- src: 04 #305, #319; 02 §3.3 -->

:::{warning}
In version 25, a single-point run whose SCF hits the iteration limit prints `no convergence!` and then carries on:
it prints an energy, orbitals and properties and exits normally. An OH radical with default settings did this after
the default 32 iterations, still creeping towards convergence; with `iterations=100` it converged after 34. Always
check for `converged!`.
:::
<!-- src: 08 t10, t28 -->

The DFT SCF runs on a coarse grid first and then switches to the final grid; the switch is marked by a new
`grid:` line with the number of points. A short jump in the gradient at that point is normal. Steady growth after it is not (see
{ref}`troubleshooting.fine-grid`).
<!-- src: 05 §7.1 -->

### Check the input first

In one well-documented failure, several input errors were present besides the SCF trouble. Before changing SCF
settings, check:

- **Multiplicity.** {ref}`mult <molecule.mult>` must match the electron count. One failing input gave `mult=0` for
  an odd number of electrons, and the summary box showed `Spin multiplicity 0`.
- **Theory and functional.** A hybrid functional with `theory=dft` is wrong; see
  {ref}`troubleshooting.hybrid`.
- **Basis.** Non-native basis sets and diffuse functions converge badly. A non-native basis file must also supply a
  fitting (auxiliary) basis, and a badly prepared one causes trouble. Use a native basis, or start from a geometry
  optimized in one.
- **Geometry.** A very poor starting geometry can by itself prevent SCF convergence. Pre-optimize with a cheap pure
  functional (for example PBE with `theory=dft`) before switching to the target method.
<!-- src: 04 #319 (input), #320, #321 (amge); 04 §8 "My observations on #319" (the research note's own analysis, not posted in the thread) -->

### Restart from saved vectors

This technique is recommended on both forums (by amg and by amge, who may be the same person), and the limor1 `pri`
driver script automates it:
<!-- src: 03 §7 (amg 2010, Gd@C60 mult=7); 04 #306 (amge 2014); 02 §5.3 (pri) -->

1. Cap the number of SCF iterations at a moderate value, for example `iterations=10` in {ref}`$scf <group.scf>`.
   Choose the cap so that `hmin` does not run away.
2. Have Priroda write its vectors with {ref}`save <control.save>` in {ref}`$control <group.control>`.
3. When the SCF ends with `no convergence!` (older versions stopped with `SCF is far from convergence`), add
   `$guess read=1 $end` (see {ref}`read <guess.read>`) and rerun with the latest geometry.
4. Repeat until the SCF converges.

```text
$control
 task=optimize
 theory=dft
 basis="basis.in"
 save=job.vec
$end
$scf iterations=10 $end
$guess read=1 $end
```
<!-- src: 08 t27, t71b (both task=energy; what a v25 optimization does after an unconverged SCF is untested) --> <!-- verify -->

In version 25 the output of a restarted run shows `Initial Guess (-1)` and `vectors from 'job.vec'`; a normal start
shows `Initial Guess (2)`. Each restart continues from where the previous run stopped, and goes straight to the
final grid instead of starting again on the coarse one. In a test on a 22-atom copper complex with 3 iterations per
run, the loop converged in the fourth run, after about 12 iterations in all.
<!-- src: 08 t27, t71b -->

Leave out the `$guess` line in the first run. Vectors from a converged run of an easier case, or of the same molecule
at another geometry, also work as a starting point.
<!-- src: 03 §7 (sanya, amg agreed); 05 §7.1 (EvgeniX, fix 2); 08 t74b (vectors of another multiplicity accepted) -->

### Switch the SCF procedure and tighten the grid

The default {ref}`procedure <scf.procedure>` is Newton–Raphson (`nr`). If it blows up, try `bfgs`, and the other way
round. One experienced user recommends this setting for difficult cases, "which is nearly all of them":
<!-- src: 04 #320 (alxyppv); keywords/scf.yaml procedure -->

```text
$scf
 convergence=1e-7
 procedure=bfgs
 iterations=250
$end
$grid
 accuracy=1e-9
$end
```
<!-- src: 04 #320; 04 #324 (amge: this fragment works); 08 t07b (the same $scf keywords on one line work in v25) -->

He notes that the default 16 iterations of the versions of that time are too few for many jobs; version 25
defaults to 32. If you tighten {ref}`convergence
<scf.convergence>` to `1e-8`, make the grid finer as well, `1e-9` or `1e-10` (see {ref}`accuracy <grid.accuracy>`).
<!-- src: 04 #320 -->

:::{note}
The user who asked never reported whether this fixed the failing job. `bfgs` is not a cure-all: in the case in the
next section it may have been part of the problem.
:::
<!-- src: 04 #319-#321; 05 §7.1 -->

(troubleshooting.fine-grid)=
### Divergence after the switch to the fine grid (open-shell transition-metal complex)

**Symptom.** A doublet Cu(II) complex (OLYP/L2, `restrict=0`, `procedure=BFGS`, `$grid acc=1e-12`, `task=hessian`)
converged on the coarse grid. After the switch to the final grid it oscillated for about 30 iterations and then
diverged, with the total energy reaching +29 hartree. BLYP behaved the same way.
<!-- src: 05 §7.1 (EvgeniX 2015) -->

:::{note}
The same molecule and SCF settings, run as a single point, converge in version 25: with the original BFGS settings in
48 iterations, and with the default Newton–Raphson procedure in 10 iterations and about half the time. The
divergence did not reproduce. If you meet it in a current version, the fixes below are still the ones to try.
:::
<!-- src: 08 t70a, t70b -->

**Fixes.** Two experienced users solved it in two ways, which they considered equivalent:

- Run `task=optimize+hessian` instead of a single-point Hessian, and drop `procedure=BFGS` and `iterations`:
  ```text
  $control task=optimize+hessian $end
  $scf restrict=0 convergence=1e-10 $end
  ```
  Each optimization step then starts from the previous wavefunction. In version 25 this route converged the
  optimization of the complex in 6 steps, with every SCF converging, and the Hessian finished: 32 minutes in all on
  8 processes, with one small imaginary frequency (6.11i cm⁻¹). <!-- src: 05 §7.1 (amge); 08 t72 (round 9, 8 processes) -->
- Save the wavefunction at the start of the optimization with {ref}`save <control.save>` and read it into the Hessian
  job with `$guess read=1`. For an already optimized structure, the guess built from scratch turned out to be poor.
  <!-- src: 05 §7.1 (EvgeniX) -->

(troubleshooting.open-shell-singlet)=
### Open-shell singlets and broken symmetry

For an open-shell (broken-symmetry) singlet, start the unrestricted singlet from the vectors of the triplet. This is
the route that worked in version 25 tests: run the triplet with {ref}`save <control.save>`, then the singlet with
`restrict=0` and `$guess read=1` (the program accepts vectors of another multiplicity). For O2 this converged, after
many iterations, to a broken-symmetry singlet 0.048 hartree below the closed-shell one and 0.015 hartree above the
triplet. Give such runs plenty of {ref}`iterations <scf.iterations>`, and check the result as described below.
<!-- src: 08 t74a-c -->

This route works only when the triplet's orbitals themselves give the singlet an asymmetric start. For O2 they did,
because the two singly occupied π* orbitals are degenerate. For stretched H2 they did not: started from the
triplet's vectors, the singlet fell back to the restricted solution.
<!-- src: 08 round 14 (H2 from triplet vectors) -->

Neither the atomic spin populations (`print=+charges`) nor the orbital energies showed that this solution was
broken-symmetry: in O2 both came out the same for broken-symmetry and closed-shell solutions, because the two π*
orbitals are spread equally over both atoms. What showed it was the energy of a second run from the same triplet
vectors with `restrict=1`, which fell back to the closed-shell energy. Use the same check when the spins do not
decide.
<!-- src: 08 t74c, t74d -->

The older sources recommend instead an unrestricted calculation with the HOMO and LUMO of the guess mixed:

```text
$scf restrict=0 $end
$guess mix=1 $end
```
<!-- src: 03 §7; 06 §10 (Alder-ene example); keywords/guess.yaml mix -->

:::{warning}
In version 25 tests `mix=1` had no visible effect: no run with it broke the symmetry, not even stretched H2 with
UHF, the textbook case. Use the triplet-vectors route above, and check the result.
:::
<!-- src: 08 t60, t73, t79 -->

See {ref}`restrict <scf.restrict>` and {ref}`mix <guess.mix>`. In version 25 tests, `restrict=0 mix=1` converged back
to the restricted solution for singlet O2 with `theory=dft` (PBE) and for the Cr2 dimer with both the default and the
`bfgs` procedure: the energies equalled the closed-shell ones exactly. With `theory=ridft` (PBE1) the O2 run also gave
identical alpha and beta orbital energies, but no closed-shell reference was run, so that case is undecided. The same
happened for H2 stretched to 2.5 Å, with both HF and PBE, for every integer value of `mix` tried (1, 2, −1, 10, 45,
90): the singlet stayed at the restricted energy, −0.8632 hartree for HF, although the triplet lies at −0.9972. An
unrestricted SCF in Priroda keeps whatever symmetry its starting orbitals have, and `mix=1` did not supply the
asymmetry.
<!-- src: 08 t60a, t60b, t73a-c, t79a-e and the round-14 runs; t48b (closed-shell reference for PBE only) -->

In a 2011 forum report with non-RI pure DFT (`theory=dft`, PBE or BLYP), `restrict=0 mix=1` likewise converged back
to the restricted solution, with identical energies and identical alpha and beta orbital energies. With RI-DFT the
same user got an unrestricted energy about 3 microhartree lower, which he took as broken symmetry. Another user notes
that pure GGA functionals often do not break symmetry, and suggests a hybrid (with `theory=ridft`) or a Hartree–Fock
calculation first.
<!-- src: 03 §7 (Evgeniy Feb 2011: RI-PBE 3.3e-6, RI-BLYP 2.8e-6 hartree lower; qadir) -->

(troubleshooting.lumo-below-homo)=
### LUMO below the HOMO

In the orbital energies printed after the SCF, the lowest virtual orbital normally lies above the highest occupied
one. If it lies below, either the SCF has settled in an excited configuration, or the molecule has a partly filled
set of degenerate orbitals that a closed-shell calculation cannot fill in order.
<!-- src: 08 t48b, t74d, t74e -->

The second case happened for singlet O2 in version 25 tests. In a closed-shell (`mult=1`) run the pair occupies one
of the two degenerate π* orbitals. The occupied orbital ended at −0.178 hartree, above the empty one at −0.219.
Starting with the two orbitals swapped ({ref}`na <guess.na>`, {ref}`nb <guess.nb>`; whether the swap took effect is
not shown in the output), or from the triplet's vectors with `restrict=1`, gave the same state and energy, since filling the other π* orbital is equivalent by symmetry. For such
molecules the closed-shell energy is not a meaningful singlet energy: use an unrestricted broken-symmetry run (see
{ref}`troubleshooting.open-shell-singlet`) or the high-spin state.
<!-- src: 08 t48b, t74d, t74e -->

The first case could not be produced in version 25 tests. Water started with its HOMO and LUMO swapped, either from
the default guess or from vectors read from a file, went back to the ground state every time; the swap only made
the SCF take two to three times more iterations. In the version 25 tests, the only persistent case was the
degenerate shell of O2.
<!-- src: 08 t75a-d -->

:::{note}
If an excited configuration does turn up in a molecule without degenerate orbitals, two tools are available: start
from other vectors (`$guess read=1` with vectors of a related calculation), or reorder the starting orbitals with
{ref}`na <guess.na>` and {ref}`nb <guess.nb>`. Neither was tested for this manual on such a case, because none was
found.
:::
<!-- src: 06 §10 (na, nb); 03 §7 (reading vectors) -->

### Heavy elements

For scalar-relativistic pure DFT with the heaviest atoms, the v5 documentation suggests
{ref}`d1small=1 <scf.d1small>`; without it, the quadratically convergent SCF may fail.
<!-- src: 06 §10; keywords/scf.yaml d1small -->

If an orbital ordering problem is suspected, {ref}`na <guess.na>` and {ref}`nb <guess.nb>` reorder the starting
vectors. <!-- src: 06 §10 -->

### Cases without a known fix

- An HF reference for CCSD diverged for a small closed-shell molecule (7 atoms, `set=L1`, `restrict=0`). The
  `change` column stuck at `0.50000000`. Nobody replied. Running a closed-shell molecule with `restrict=0` was
  unusual and may be worth changing.
  <!-- src: 05 §7.2 (EvgeniX 2015; the restrict=1 suggestion is the research note's own interpretation) -->
- An HfCl2 molecule (PBE, `four=1`, `basis4.in`, `set=L3`, `accuracy=1e-10`) would not converge. Nobody replied.
  Two things in the posted input are worth checking in such a case (this is the manual's observation, not a tested
  fix): it had `$guess read=1` in the same job that wrote the vectors with `save=`, so the start depended on whatever
  vector file already existed; and it used `mult=1` for a d² Hf(II) compound.
  <!-- src: 05 §7.3 (YuraM 2016; input has save=m1_HfCl2_1.chk, $guess read=1, mult=1) -->

(troubleshooting.optimization)=
## Geometry optimization problems

### The optimization does not converge within `steps`

The default limit is 128 steps in version 25 and 50 in older versions (see {ref}`steps <optimize.steps>`). When the
limit is reached, the output just ends: there is no message and no `MOL>` block. `Dft.rtf`, an older unofficial
Russian description, warns that an optimization not converged after about 50 steps very likely has something wrong
with it, and that computing a Hessian first helps in many cases. So don't simply raise `steps`. What users do:
<!-- src: keywords/optimize.yaml steps; 08 t12, t14; Dft.rtf (00_Dft_rtf_utf8.txt line 83) -->

- **Restart from the last geometry.** The limor1 `pri` script restarts Priroda from the last geometry whenever an
  optimization runs out of steps. This helps when the optimizer cycles around one geometry even after 300 steps.
  <!-- src: 02 §5.4 (pri); 06 §10 (FAQ, lastgeo) -->
- **Supply a Hessian.** Run `task=hessian`, append its `$Energy` block (the `eng>` lines) to the input, and optimize
  again. See {ref}`$Energy <group.Energy>`. <!-- src: 06 §10; 02 §5.4 -->
- **Use Cartesian coordinates.** {ref}`cartesian=1 <optimize.cartesian>` is called a last resort on the v5 keyword
  page, but the limor1 `conformers` script uses it for automated runs, and one experienced user says floppy systems
  such as explicit solvation shells have to be optimized in Cartesian coordinates. In version 25 tests on CO2 and
  acetylene it needed 6 steps, against 12 and 24 in internal coordinates.
  <!-- src: 06 §10; 02 §5.4 (conformers); 04 #352; 08 t76a-e -->

One experienced user found Priroda's optimizer weaker than Gaussian's, while its SCF is stronger (2013).
<!-- src: 04 #194 -->

### Crash with `process 0 got signal 6` and `too few`

**Symptom.** The optimization dies with `process 0 got signal 6`. In the output of the last step, the
`INTERNAL COORDINATES` table ends with `too few`.

**Fix.** Optimize in Cartesian coordinates:

```text
$optimize cartesian=1 $end
```

This was the answer from one experienced user; the asker did not report back.
<!-- src: 04 #517, #518 (Jul 2026) -->

The crash could not be reproduced in version 25 tests with molecules that become linear, the usual suspects for
running short of internal coordinates. CO2 and acetylene started bent converged in internal coordinates: the
optimizer rebuilt its coordinate set when the molecule became linear (from 5 to 4 coordinates for CO2, from 9 to 7
for acetylene) and carried on. They needed 12 and 24 steps, against 6 each with `cartesian=1`.
<!-- src: 08 t76a-e -->

### The optimization "converges" in one step

A run that reports convergence after a single step, with an energy that is not a number, did not optimize anything:
the SCF failed on the first step. See {ref}`troubleshooting.nan`.
<!-- src: 04 #334-#336 -->

### A symmetric structure stays symmetric

Without the symmetry options, Priroda works in C1, but a symmetric starting geometry often stays symmetric through
an optimization that converges normally, and the Hessian then shows a saddle point. If the optimization did not break the symmetry, always
compute the Hessian. If it has an imaginary frequency, paste its `$Energy` block into the input, displace the
geometry along that mode if needed, and optimize again.
<!-- src: 04 #254 (amge); 06 §10 (re-optimize with lasteng) -->

Version 25 can also use symmetry on purpose: `$molecule sym=1,0.01` detects the point group and symmetrizes the
input geometry, and `$optimize sym=1` keeps that symmetry during the optimization. Both options are needed. See
{ref}`$molecule sym <molecule.sym>` and {ref}`$optimize symmetry <optimize.symmetry>`.
<!-- src: 08 t15, t30a, t30b -->

### A scan starts from a mangled geometry

**Cause.** Priroda's dihedral angles have the opposite sign to the convention used by Molden, MOPAC and GAMESS. A dihedral {ref}`value <optimize.value>` copied from another program makes the first scan point a
scrambled structure that has nothing to do with the input geometry.

**Fix.** Flip the sign of every dihedral value taken from another program. The user who hit this confirmed that
flipping the signs fixed it. The user who answered (amge) had reported the sign difference on qchem.ru in 2008, for
"all versions" of that time. Neither report covers version 25.
<!-- src: 04 #271, #276, #278, #279 (confirmed); 03 §15 (amg, Oct 2008; amg and amge are probably the same person) --> <!-- verify -->

A scan that requested 10 points but computed only 7 (and 11 of 20) was reported once and never explained.
<!-- src: 04 #60; 04 §21 -->

### IRC gives only two points, or no curve

An IRC must start from a properly optimized transition state with an accurate Hessian in the input. Find the TS
first (`task=optimize` with {ref}`saddle=1 <optimize.saddle>`), compute the Hessian there, check that it has exactly
one imaginary frequency and that this mode is the reaction you want, and only then run `task=irc`. In one reported
case, an IRC started from an unoptimized geometry gave two points with {ref}`back=0 <optimize.back>` and no curve
with `back=1`; an experienced user called this typical of an under-optimized geometry.
<!-- src: 04 #92, #93, #100, #102 -->

### IRC stops with `Vicinity of a Stationary Point(?) --- STOP.`

This message is also the normal end of an IRC that has reached a minimum: a version 25 test IRC of the ammonia
inversion ended with it after 7 points, at the minimum. It is a problem only when it comes early.
<!-- src: 08 t26 -->

On the first IRC step this means that the energy did not go down on that step. The reported fix is to change the
step size; see {ref}`radius <optimize.radius>`:

- on a very flat barrier top, increase the step so that it reaches the slope;
- on a very narrow barrier, such as a proton transfer, decrease it, because a step suited to heavy atoms throws the
  proton too far.

This advice comes from one experienced user. <!-- src: 04 #295, #298 -->

In a version 25 test on a hydrogen shift (HCN ⇄ HNC), step sizes of 0.03 and 0.1 (the default) reached both minima
without stopping early; 0.3, run toward HCN only, also reached its minimum. So the default is a sensible start even
for a light atom. The step size changed the cost and how close to the minimum the path ended: 60–69 points with
0.03, 19–21 with 0.1, and 7 with 0.3, which stopped farthest from the minimum (gradient 0.010 against 0.0003–0.006).
<!-- src: 08 t77d-h -->

An IRC can also end with `Energy Minimum Passed --- STOP.` right after the `Vicinity` message, when its last point
overshot the minimum and came out higher in energy than the one before. This is a normal end too. <!-- src: 08 t77d, t77g, t77h -->

### IRC ends near a minimum but not in it

This is normal: always re-optimize both IRC endpoints. An IRC can also stop on a flat shelf where the gradient is
small, or at another TS. Then compute a Hessian at the stopping point and run a new IRC from there; this sometimes
has to be repeated three or four times. Priroda has no option to recompute the Hessian every n steps.
<!-- src: 04 #313, #314 -->

(troubleshooting.results)=
## Wrong or suspicious results

(troubleshooting.hybrid)=
### Hybrid functional silently ignored

**Cause.** Hybrid functionals (B3LYP, PBE0/PBE1, ...) are applied only with {ref}`theory=ridft <control.theory>`.
With `theory=dft` or `theory=tddft`, older versions (reported for v6 to v8) ran without any error message but used
zero exact exchange: the exact-exchange part was simply dropped, so the result matched neither the hybrid nor a pure
GGA. The developer was told about
it and, according to a user who corresponded with him, did not intend to change it.
<!-- src: 03 §11 (sanya, amg); 04 #96, #99, #310; 08 t46 (what dropping exact exchange does) -->

Newer builds (reported in 2014) refuse with `theory=dft`: the job prints `Basis set input:` twice and stops with
`application called MPI_Abort(MPI_COMM_WORLD, 1) - process 0` (on stderr), before the summary box. Another user
reproduced it with a known-good input, and version 25 does the same.
<!-- src: 04 #307-#310; 08 t08 -->

:::{warning}
**With `theory=tddft` the trap is still open in version 25.** A water run with `functional=PBE1` showed `PBE1` in the
summary box, finished normally and printed excited states, but the exchange energy was −6.61 instead of about
−8.95 hartree and the total energy was about 2.2 hartree too high: the exact-exchange part was simply left out. Any
TDDFT result with a hybrid functional is wrong.
:::
<!-- src: 08 t46 (compare t31b and t01) -->

**Fix.** Use `theory=ridft` for every hybrid ground-state calculation, and a pure GGA functional (PBE, the default)
for TDDFT. There is no hybrid TDDFT in Priroda.
<!-- src: 03 §11; 04 #310; 08 t46 -->

(troubleshooting.nan)=
### NaN energy, or an optimization that stops after one step

**Cause.** The SCF energy on the first step is not a number, so the optimizer stops at once and reports convergence.
The reported causes are all basis problems:

- **No basis for an element.** A molecule containing Bi was run with `3z.bas`, which covers only Z ≤ 54. Use
  `sbk.bas` (ECP basis up to Rn, Z ≤ 86) or `basis4.in` with {ref}`four=1 <control.four>`.
  <!-- src: 04 #334-#336 (Гесс, amge); 01 §3.4, §6.1 (sbk.bas: ECP and 3z basis up to Z = 86) -->
- **ECP not read.** In one case nothing was computed and there was no error message. The output showed zeros for one
  element in the basis table, and no sign that the ECP had been read. The cause was a defect in the user's basis file;
  `20+sbk.bas` worked. <!-- src: 04 #447-#451 -->
- A NaN at the first SCF iteration for [PtCl6]2- with the St-rsc-97 ECP basis went away after switching to the
  `sbk(u)` basis. Why that basis failed is not known. <!-- src: 04 #454, #455; 04 §21 -->

**What to check.** In the output, the ECP should be read before the basis, and every atom in the basis table should
have a non-zero number of basis functions.
<!-- src: 04 #448 (Гесс) -->

### TDDFT oscillator strengths are all zero

A closed-shell TDDFT run on version 25 printed non-zero oscillator strengths in its `Electronic Spectrum:` table
with the default settings. <!-- src: 08 t33 -->

The reported cause of all-zero values: with `restrict=0` set explicitly, singlet and triplet excitations get mixed.
Use {ref}`$scf restrict=1 <scf.restrict>` (the default for a closed-shell singlet) and compute one multiplicity per
run.
The user who reported the problem confirmed the fix.
<!-- src: 03 §11 (Marsel, sanya) -->

### The dipole moment is zero

Version 6 printed `dipole =   0.000000 au (  0.000000 D)` for every molecule when relativistic basis sets were used,
even with `task=dipole`. Version 8 and later print a value.
<!-- src: 04 #32-#35 -->

### Energies differ between Priroda versions

Newer builds are faster but give slightly different total energies for the same input. Do not compare close
energies computed with different versions; within one version the comparison is fine.
<!-- src: 04 #514 (amge, 2026) -->

### The printed energy components do not add up to E

The line `T = ... V = ... J = ... Ex = ... Ec = ...` does not include the nuclear repulsion energy, so the
components do not sum to `E`. This is not an error: E = T + V + J + Ex + Ec + E(nn). The answer came from the developer,
relayed by a user.
<!-- src: 04 #375, #382 (Laikov, relayed) -->

### Thermochemistry of single atoms

For a monoatomic species the enthalpy has an extra RT, and the rotational entropy is printed as `-inf`. Correct these
by hand and keep only the translational terms.
<!-- src: 03 §15 (Evgeniy, Llewule); 04 #80 (EvgeniX) -->

### Results depend on the number of processes

In one unstable TS search started from a poor guess, the optimization followed different paths with different
`-np`. Normally the results differ only in insignificant digits.
<!-- src: 03 §3 (amg, Nov 2008) -->

(troubleshooting.memory)=
## Memory, disk and scratch errors

All {ref}`$system <group.system>` limits apply per MPI process. With `disk=10` on four processes, up to 40 GB can be
used. <!-- src: 03 §3; keywords/system.yaml -->

### `need … bytes.`

**Cause.** The {ref}`memory <system.memory>` limit in `$system` is too small for the job. Version 25 stops right after
the basis-set echo with a line such as `need 12544 + 7905408 = 7917952 bytes.` (here for water with `mem=2`); the
last number, in bytes (here about 7.6 MB), is what the job needs at that point. Set `memory` (in MB) above it.
<!-- src: 08 t61 -->

### `malloc(...) failed`

**Cause.** Priroda could not allocate the memory requested in {ref}`memory <system.memory>`, plus any RAM disk
requested with a negative {ref}`disk <system.disk>`. The number in the message is the request in bytes.
<!-- src: 04 #58, #94, #463, #464 -->

**Fix.** Ask for less than the node really has free:

- With a RAM disk, `memory` plus |`disk`| (both in MB), times the number of processes, must fit in physical RAM.
  One experienced user's example for a 24 GB node, `memory=9000 disk=-14000`, assumes one process per node. Another
  user's limit, `memory=9250 disk=-9250`, fits this rule.
  <!-- src: 04 #196 (values per process); 03 §3; 04 #462, #463, #468, #471 -->
- The 32-bit Windows (Cygwin) builds cannot allocate more than about 1 GB. 512 MB was enough for most DFT jobs.
  Several users confirmed this limit. The 64-bit Windows build with `cygwin1.dll` is reported to have no such limit.
  <!-- src: 04 #94, #95, #104, #105, #210, #211, #370 -->

A message beginning `We need 1.5 GB of memory...` was reported once. One reply guessed that it is about RAM
(`memory=`), not disk space. It may be an older form of the `need … bytes.` message above.
<!-- src: 04 #463, #464; 08 t61 (v25 wording differs) -->

### `out of disk space`

**Symptom.** `0: out of disk space (VNNNN), <N>KB`, or a similar message naming another array, such as
`(ci.Rnvvo)`. Version 25 with a 1 MB RAM disk (`disk=-1`) printed `0: out of disk space (grid_W), 8213824`.
<!-- src: 04 #289; 08 t62 -->

**Fix.**

- Raise {ref}`disk <system.disk>` above the amount reported. Remember that the value is per process.
  <!-- src: 03 §4; 04 #289, #290 -->
- Conventional MP2 is very disk-hungry. Use `theory=rimp2` instead.
  <!-- src: 03 §4 (sanya, Evgeniy) -->
- Check that `cartesian` or `z-matrix` in `$molecule` matches the coordinates you actually gave; wrong coordinates
  can make the job far bigger than intended. <!-- src: 03 §4 (Evgeniy) -->

Each scratch file is created for 1 GB per process and filled as needed. Jobs needing more than 20–45 GB of scratch
were, in one experienced user's words, not worth their cost.
<!-- src: 04 #290; 03 §4 -->

A failure to read a scratch file during MP2 (`0: read file ./tmp/...`) was given the same fix.
<!-- src: 03 §4 (Marsel, Feb 2010) --> <!-- verify -->

### A small RI-MP2 job does not fit in memory

A 7-atom RI-MP2 job with `four=1`, `basis4.in` and `set=L22` claimed not to fit in memory however much was given,
while smaller and larger basis sets ran. A second user reproduced it and got `0: write VMNN(11753704:14042536)?`.
The first user found that direct integrals avoid the problem:

```text
$integral direct=1 $end
```

See {ref}`direct <integral.direct>`. <!-- src: 05 §4.2 (EvgeniX, amge 2015) -->

### Where scratch files go

Priroda writes scratch files to the directory given by {ref}`path <system.path>`; if `path` is not set, to
`$TMPDIR`; otherwise, in version 25, to `/tmp` (a 2020 user report said the directory of the input file). On a
cluster, `/tmp` is often too small or quota-limited for large scratch files. Use the cluster's local scratch area, or
a RAM disk with a negative `disk` value. Never put scratch on NFS.
<!-- src: 04 #462, #465; 06 §10; 08 t64 -->

A job that stops while writing a scratch file, with a message like
`0: write file /tmp/tmp9633.11 (leAX): fd=21 ...`, was reported once (2020) during an analytic Hessian on a cluster.
An experienced user replied that no `path=` was set, so scratch went to `/tmp`, probably on the master node, where
quotas can make the job fail, and advised the cluster's scratch area. The asker then tried a `tmp` folder and got the
same error; the case was not resolved. Check the free space, the quotas and the `disk=` setting.
<!-- src: 04 #460, #462, #463 -->

If Priroda does not get enough memory or scratch, it stops with an error; it does not fall back to a slower
algorithm. <!-- src: 04 #199 -->

### Slow runs: disk speed

Priroda is very demanding of disk speed. For all methods except GGA DFT, `input.txt` warns that performance
degrades "terribly" if more than one process reads and writes large files on the same physical drive. Options, in order of
preference:

- keep scratch in RAM with a negative {ref}`disk <system.disk>` value (one cluster reported a 6× speed-up for
  RI-MP2);
- give each process its own physical drive with a colon-separated {ref}`path <system.path>` list;
- if the job is disk-bound, switch to direct integrals with {ref}`direct=1 <integral.direct>`. This costs CPU time but
  can be much faster overall: one RI-MP2 optimization went from 2 to 20 steps per night.
<!-- src: 04 #181, #192, #194, #293; 03 §3, §17; input.txt lines 39-41 -->

(troubleshooting.parallel)=
## Parallel and MPI problems

### A parallel RI job hangs with no message

**Cause.** RI methods, RI-MP2 and RI-DFT included, hang forever if any process gets no work. This happens when the job
is too small for the number of processes. Two experienced users confirmed it and called it a bug.

**How to recognize it.** After `integral estimates`, the output lists the blocks per node. In a normal run every node
has work, as here; a hung job shows `0 blocks` on some node:

```text
    2892490 blocks,    103625770 integrals on node  0
    3681560 blocks,     91256706 integrals on node  1
```

**Fix.** Run small RI jobs on fewer processes, or on one core.
<!-- src: 05 §3.1 (EvgeniX, amge 2015) -->

Older reports describe similar hangs: small jobs on many processors hang (v6/v7); MP2 on a 102-atom complex died with
signal 8 on more than about 24 cores (v7, MVAPICH); a v6 Hessian on 4 cores could hang at `Solving for responses ...`.
The v6 advice was at most 2 cores for a Hessian and at most 4 for an optimization. Another user ran DFT, including
Hessians, on 24–32 cores without trouble, so this advice is disputed. In 2018 an experienced user said the Windows
builds run in parallel only from version 16, and that the v6 Hessian uses at most 2 cores, the v17 one 4 or more.
<!-- src: 03 §3, §15 (Evgeniy, sanya); 04 #401 -->

### Little or no speed-up from more cores

- Reports on DFT scaling within one node disagree: one experienced user found at most 10% more from 32 cores than
  from 6–8, while another measured 101, 63 and 37 s for the same optimization on 8, 12 and 24 cores.
  <!-- src: 04 #343, #344 (2016) -->
- For DFT, running across several nodes gives no gain; one experienced user said so on three occasions. RI-MP2 is
  different: in a v8 benchmark on 4 nodes with scratch in RAM it ran 6× faster than on 2 cores of one node.
  <!-- src: 04 #344, #417, #462 (all amge); 03 §3 (v8 benchmark, Evgeniy 2008) -->
- In a DFT run most of the memory and all the disk I/O stay on rank 0, so spreading a DFT job over nodes does not
  spread its memory. RI-MP2 distributes memory better.
  <!-- src: 03 §3 (v8 benchmarks); 04 #185, #343 -->
- For throughput, several single-core jobs at once can beat one multi-core job when the jobs are not disk-bound.
  <!-- src: 03 §3 (amg) -->
- For RI-MP2, the v5 documentation suggests a number of processes that divides the number of occupied orbitals.
  <!-- src: 06 §10 -->

### `Environment is too large (max is 193)`

**Symptom.** A parallel run started with the `mpiexec` from the official site prints this line (once per process)
and stops at once; no output file is written. Typically this happens inside a batch job.

**Cause.** That `mpiexec` refuses to start when the environment holds 193 or more variables. Batch systems add many
variables of their own; a Slurm job in a version 25 test had 210.

**Fix.** Start it with a minimal environment:

```text
env -i PATH="$PATH" HOME="$HOME" TMPDIR="$TMPDIR" ./mpiexec -np 4 ./p input.in output.out
```

See {ref}`running-batch` for a complete job script.
<!-- src: 08 Slurm tests (s01 as written; 192 variables run, 193 refused) -->

### Starting a parallel run on Linux

A parallel version 25 run must be started through an MPI launcher, such as the `mpiexec` from the official site:
`./mpiexec -np 4 ./p job.in job.out`. `./p -np 4 job.in job.out`, which worked in versions 6 and 10, now stops with
`input file '-np'?.`. With version 10, starting through the bundled `mpiexec` once failed with
`Error in system call mpiexec: No such file or directory` or `mpiexec could not exec p`. Use absolute paths for the
binary, the input, the output and the basis file.
<!-- src: 04 #150, #152-#154; 01 §2.1; 08 t21a, t21b (bundled mpiexec works in v25) -->

The message `OOPS: semop lock failed` (with `process N received signal 2` or `6`) has two reported contexts:

- as a secondary message after another fatal error, such as running out of disk. Fix the first error;
  <!-- src: 03 §8 (denis) -->
- in v6 shared-memory runs on 7 cores. Fewer cores avoided it; cleaning semaphores with `ipcrm` did not help.
  <!-- src: 03 §15 (Chai, Evgeniy) -->

It also appeared for one user who ran as a normal user while the same input worked as root. That case was never
resolved. <!-- src: 04 #172-#174 -->

A run that stops producing output right after the header, while the process keeps using CPU, has been reported and
called common. The only advice was to look for stray files named after the input or output in the input, output,
program and home directories, and then to rule out causes one by one. <!-- src: 04 #315-#318 -->

### Windows

Old Windows builds were serial only. For a parallel 64-bit run (version 16 or later), users report this setup:
<!-- src: 04 #66, #99, #370, #397, #401, #472 -->

1. From a 64-bit Cygwin installation with OpenMPI, copy `cygwin1.dll`, `cyggcc_s-seh-1.dll`, `cygmpi-12.dll`,
   `cygopen-pal-13.dll`, `cygopen-rte-12.dll` and `orterun.exe` next to the Priroda executable. Take
   `cygwin1.dll` from the same Cygwin installation, because the other DLLs work only with it. These are the names
   from a 2017 Cygwin. A 2018 report says newer OpenMPI packages ship `cygopen-pal-40.dll` and
   `cygopen-rte-40.dll` instead; take those.
2. To run outside the Cygwin terminal, create a `dev` directory one level above the directory you start Priroda from,
   with subdirectories `shm` and `mqueue`. For Priroda in `C:\Priroda 16` that means `C:\dev\shm` and
   `C:\dev\mqueue`. Without them Cygwin prints `Warning: '/dev/shm' does not exists or is not a directory.`
3. Set `TMPDIR` and start the run from `cmd.exe`:
   ```text
   cd /d "C:\Priroda 16"
   set TMPDIR="%TEMP%"
   "orterun.exe" -np 2 ./p16_64_parallel.exe "C:\Work\file.in" "C:\Work\file.out"
   ```
   This is the command as posted. In `cmd.exe`, `set TMPDIR="%TEMP%"` keeps the quotes as part of the value;
   `set "TMPDIR=%TEMP%"` does not. Which form the Cygwin build expects was not tested.
4. If the program is in a system directory such as `C:\Program Files`, run it as administrator.
<!-- src: 04 #370 (EvgeniX), #360, #362, #472 --> <!-- verify -->

Network problems reported with this setup:

- On a PC connected by WiFi that also has a LAN adapter, OpenMPI failed with
  `tcp_peer_send_blocking: send() to socket 12 failed`. Disabling the LAN adapter fixed it (single report).
  <!-- src: 04 #397 --> <!-- verify -->
- With the Ethernet cable unplugged, only some cores were used. Plugging it back in fixed it (single report).
  <!-- src: 04 #374 --> <!-- verify -->

A 2021 attempt to follow this recipe on Windows 10 failed with an error that was posted only as a screenshot; no fix
was posted. One user runs Priroda under WSL on Windows instead; no details of that setup were posted.
<!-- src: 04 #472, #508 -->

:::{warning}
Not every build on the official site is reliable. A note there once said that the `w64/*.exe` 64-bit Cygwin builds
had a DFT/ECP bug. If a Windows build misbehaves, ask the developer which build you should be running.
:::
<!-- src: 04 #366 -->
