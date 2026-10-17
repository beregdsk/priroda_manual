(troubleshooting.common-problems)=
# Solving common problems

This chapter is arranged by symptom. Each entry names the likely cause and the fix that users have reported. If you
already have an error message, look it up first in {ref}`the error message index <troubleshooting.error-messages>`.

Almost everything here comes from user forums, not from the author. Each fix says how well it is supported:
"confirmed by several users" means more than one person reported that the fix worked, and "single report" means one
user posted it and nobody confirmed it. Many reports date from Priroda 6 to 10 (2009–2015). Where a problem may
have been fixed in later builds, the entry says so.

:::{note}
None of the fixes below has yet been checked against a current Priroda binary.
:::

(troubleshooting.input)=
## The input is not read, or is read wrongly

When Priroda cannot parse the input it usually stops early, often right after echoing `molecule input: ''`, and gives
no explanation. Before anything else, open the output and check what it echoed back: the `System options` block, the
`scf options:` line, the `grid:` line and the summary box (number of atoms, charge, multiplicity, method,
functional). If a value you set is not shown there, Priroda did not read it.
<!-- src: 05 §5 (echo lines), 04 #319 -->

### Output stops after `molecule input: ''`

**Cause.** In almost every reported case the input file had Windows (CRLF) line endings. The tail of the output then
shows a mangled keyword followed by `?`, for example `' ?matrix`, `?rtesian` or `'z-matrix' ?`. Inputs saved as
Unicode, or edited in Word, fail the same way. Word's "save as text" still writes CRLF line endings.
<!-- src: 04 #63-#65, #104, #113, #117; 03 §2 (Dimylko, amg) -->

**Fix.** Save the input as plain ASCII text with Unix (LF) line endings, for example with `dos2unix input.in`.
Notepad++ and Far Manager (Shift+F2 in the editor) can also convert line endings. Use straight quotes only. Several
users confirmed this fix. Running `dos2unix` on a file that already has LF endings does no harm.
<!-- src: 04 #64, #65 (confirmed), #174; 03 §2 -->

A second cause gives the same first line: atomic numbers written as real numbers (`25.0` instead of `25`) in
`$molecule`. In that case the output continues with `illegal charge/multiplicity`. Write atomic numbers as integers.
This fix was posted by one experienced user.
<!-- src: 03 §5 (Evgeniy, Aug 2011) --> <!-- verify -->

Avoid Cyrillic letters and spaces in the computer name, directory names and file names. One user's problem with this
output went away after he had dealt with both line endings and such names.
<!-- src: 03 §2 (amg, Nov 2011; Dimylko resolved) -->

### `task=scan` runs an optimization, or nothing works on one machine

An input that runs on one computer but not on another, or a `task=scan` that silently runs a plain optimization, has
been traced to the same encoding problem: an input edited in Word or saved as Unicode. Fix it as above.
<!-- src: 04 #110, #113 -->

Two `task=` lines in one input do not chain jobs. Only the first one runs, and no error is printed. The only combined
task that works is `task=optimize+hessian`; see {ref}`task <control.task>`. Run other sequences, such as optimization
followed by NMR, as separate jobs.
<!-- src: 04 #69, #70 -->

### The basis file is not found

- Quote file names with straight double quotes: `basis="3z.bas"`. Two single quotes (`basis=''3z.bas''`) give
  `error opening file ''3z.bas''`, and typographic quotes copied from a web page or word processor fail too.
  <!-- src: 03 §2 (denis, Evgeniy); 04 #64 -->
- Give an absolute path to the basis file if Priroda is not started from the directory that contains it. One user's
  parallel run aborted with `MPI_Abort` until he wrote the full basis path in the input.
  <!-- src: 04 #152-#154 --> <!-- verify -->
- The relativistic basis file `basis4.in` needs {ref}`four=1 <control.four>` in {ref}`$control <group.control>`.
  Without it the job stops at the `Basis set input:` line. The user who reported this confirmed the fix.
  <!-- src: 04 #206-#208 -->
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

File names are case-sensitive, unlike keywords. One user saw the extra complaint `0: output file 'tasK.out'?` when
the file name contained capital letters. Using lower-case names for input and output avoids it; this is a single
observation.
<!-- src: 04 #161; 06 §10 (case-sensitive names) --> <!-- verify -->

On Windows, `cd` into the folder with the input before running `p.exe input.in output.out`. One user still got
`cannot open input file` after doing that, and the thread never found the cause.
<!-- src: 04 #130-#133 -->

### Output stops at `0: opening file /tmp/...` (Windows)

Old Windows builds put scratch files in `/tmp` when nothing else is set (the output echoes `Disk:   1 GB '/tmp'`),
and Windows has no `/tmp`. Set the scratch directory
explicitly, for example `$system path=. $end`, or set the `TMPDIR` environment variable before starting the program.
This is the oldest known problem in both forums and the fix is well established. See {ref}`path <system.path>`.
<!-- src: 03 §2 (#0, GemmaNC 2009); 04 #20, #21, #128 -->

### `$scf` settings are ignored or rejected

Two problems are reported when {ref}`convergence <scf.convergence>` and {ref}`iterations <scf.iterations>` appear
together in {ref}`$scf <group.scf>`:

- The parser stops with `*** error in '$scf' : unknown name erations`, or the rest of the group is silently
  skipped. One user found that the order of the two keywords mattered; another got the error in either order.
  <!-- src: 05 §5.1 (EvgeniX, amge 2015) -->
- In a different test, the pair worked only when {ref}`procedure=bfgs <scf.procedure>` was also given.
  <!-- src: 04 #322-#324 -->

:::{warning}
These reports conflict and come from 2015 builds. Until this is checked on a current build, put `iterations` before
`convergence` on separate lines, and confirm both values in the `scf options:` line of the output, for example
`scf options: conv=1.0e-07, 1.0e-03; iter=250,16`.
:::
<!-- src: 05 §5, §5.1; PLAN §3 --> <!-- verify -->

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
- `no convergence!` followed by `SCF is far from convergence`, after which Priroda stops.
<!-- src: 04 #305, #319; 02 §3.3 -->

The DFT SCF runs on a coarse grid first and then switches to the final grid; the switch is marked by a new
`Grid: ... points` line. A short jump in the gradient at that point is normal. Steady growth after it is not (see
{ref}`troubleshooting.fine-grid`).
<!-- src: 05 §7.1 -->

### Check the input first

In several reported failures the SCF was not the real problem. Before changing SCF settings, check:

- **Multiplicity.** {ref}`mult <molecule.mult>` must match the electron count. One failing input gave `mult=0` for
  an odd number of electrons, and the summary box showed `Spin multiplicity 0`.
- **Theory and functional.** A hybrid functional with `theory=dft` is wrong; see
  {ref}`troubleshooting.hybrid`.
- **Basis.** Non-native basis sets and diffuse functions converge badly. Priroda's auxiliary (fitting) bases are not
  designed for foreign orbital bases. Use a native basis, or start from a geometry optimized in one.
- **Geometry.** A very poor starting geometry can by itself prevent SCF convergence. Pre-optimize with a cheap pure
  functional (for example PBE with `theory=dft`) before switching to the target method.
<!-- src: 04 #319 (input), #320, #321 (amge); 04 §8 "My observations on #319" (note author's analysis, not posted in the thread) -->

### Restart from saved vectors

This is the technique most often recommended by experienced users, on both forums, and the limor1 `pri` driver
script automates it:
<!-- src: 03 §7 (amg 2010, Gd@C60 mult=7); 04 #306 (amge 2014); 02 §5.3 (pri) -->

1. Cap the number of SCF iterations at a moderate value, for example `iterations=10` in {ref}`$scf <group.scf>`.
   Choose the cap so that `hmin` does not run away.
2. Have Priroda write its vectors with {ref}`save <control.save>` in {ref}`$control <group.control>`.
3. When the run stops with `SCF is far from convergence`, add `$guess read=1 $end` (see {ref}`read <guess.read>`)
   and rerun with the latest geometry.
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
<!-- verify -->

Leave out the `$guess` line in the first run. Vectors from a converged run of an easier case, or of the same molecule
at another geometry, also work as a starting point.
<!-- src: 03 §7 (sanya, amg agreed) -->

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
<!-- src: 04 #320; 04 #324 (amge: this fragment works) --> <!-- verify -->

He notes that the default 16 iterations are too few for many jobs. If you tighten {ref}`convergence
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

**Fixes.** Two experienced users solved it in two ways, which they considered equivalent:

- Run `task=optimize+hessian` instead of a single-point Hessian, and drop `procedure=BFGS` and `iterations`:
  ```text
  $control task=optimize+hessian $end
  $scf restrict=0 convergence=1e-10 $end
  ```
  Each optimization step then starts from the previous wavefunction. <!-- src: 05 §7.1 (amge) --> <!-- verify -->
- Save the wavefunction at the start of the optimization with {ref}`save <control.save>` and read it into the Hessian
  job with `$guess read=1`. For an already optimized structure, the guess built from scratch turned out to be poor.
  <!-- src: 05 §7.1 (EvgeniX) -->

### Open-shell singlets and broken symmetry

For an open-shell (broken-symmetry) singlet, use an unrestricted calculation and mix the HOMO and LUMO of the guess:

```text
$scf restrict=0 $end
$guess mix=1 $end
```
<!-- src: 03 §7; 06 §10 (Alder-ene example); keywords/guess.yaml mix -->

See {ref}`restrict <scf.restrict>` and {ref}`mix <guess.mix>`. With non-RI pure DFT (`theory=dft`, PBE or BLYP), one
user found that `restrict=0 mix=1` converged back to the restricted solution, with identical energies and identical
alpha and beta orbital energies. RI-DFT broke the symmetry in his case. Another user notes that pure GGA functionals
often do not break symmetry, and suggests a hybrid (with `theory=ridft`) or a Hartree–Fock calculation first.
<!-- src: 03 §7 (Evgeniy Feb 2011; qadir) --> <!-- verify -->

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
  <!-- src: 05 §7.2 (EvgeniX 2015; the restrict=1 suggestion is the note author's interpretation) -->
- An HfCl2 molecule (PBE, `four=1`, `basis4.in`, `set=L3`, `accuracy=1e-10`) would not converge. Nobody replied.
  <!-- src: 05 §7.3 (YuraM 2016) -->

(troubleshooting.optimization)=
## Geometry optimization problems

### The optimization does not converge within `steps`

The default limit is 50 steps (see {ref}`steps <optimize.steps>`). The documentation's advice is that an optimization
still running after about 50 steps usually has some other problem, and raising `steps` rarely helps. What users do
instead:
<!-- src: keywords/optimize.yaml steps; 06 §10 -->

- **Restart from the last geometry.** The limor1 `pri` script restarts Priroda from the last geometry whenever an
  optimization runs out of steps. This helps when the optimizer cycles around one geometry even after 300 steps.
  <!-- src: 02 §5.4 (pri); 06 §10 (FAQ, lastgeo) -->
- **Supply a Hessian.** Run `task=hessian`, append its `$Energy` block (the `eng>` lines) to the input, and optimize
  again. See {ref}`$Energy <group.Energy>`. <!-- src: 06 §10; 02 §5.4 -->
- **Use Cartesian coordinates.** {ref}`cartesian=1 <optimize.cartesian>` is described in the documentation as a
  last resort, but users find it more robust for automated runs and for floppy systems such as explicit solvation
  shells. <!-- src: 06 §10; 02 §5.4; 04 #352 -->

Users also say that Priroda's optimizer is weaker than Gaussian's, while its SCF is stronger.
<!-- src: 04 #194 -->

### Crash with `process 0 got signal 6` and `too few`

**Symptom.** The optimization dies with `process 0 got signal 6`. In the output of the last step, the
`INTERNAL COORDINATES` table ends with `too few`.

**Fix.** Optimize in Cartesian coordinates:

```text
$optimize cartesian=1 $end
```

This was the answer from one experienced user; the asker did not report back.
<!-- src: 04 #517, #518 (Jul 2026) --> <!-- verify -->

### The optimization "converges" in one step

A run that reports convergence after a single step, with an energy that is not a number, did not optimize anything:
the SCF failed on the first step. See {ref}`troubleshooting.nan`.
<!-- src: 04 #334-#336 -->

### A symmetric structure stays symmetric

Priroda always works in C1, but a symmetric starting geometry often stays symmetric through an optimization that
converges normally, and the Hessian then shows a saddle point. If the optimization did not break the symmetry, always
compute the Hessian. If it has an imaginary frequency, paste its `$Energy` block into the input, displace the
geometry along that mode if needed, and optimize again.
<!-- src: 04 #254 (amge); 06 §10 (re-optimize with lasteng) -->

### A scan starts from a mangled geometry

**Cause.** Priroda's dihedral angles have the opposite sign to the convention used by Molden, MOPAC, GAMESS and most
other programs. A dihedral {ref}`value <optimize.value>` copied from another program makes the first scan point a
scrambled structure that has nothing to do with the input geometry.

**Fix.** Flip the sign of every dihedral value taken from another program. The user who hit this confirmed that
flipping the signs fixed it, and the sign difference is reported independently on the other forum.
<!-- src: 04 #271, #276, #278, #279 (confirmed); 03 §15 (amg) -->

A scan that requested 10 points but computed only 7 (and 11 of 20) was reported once and never explained.
<!-- src: 04 #60; 04 §21 -->

### IRC gives only two points, or no curve

An IRC must start from a properly optimized transition state with an accurate Hessian in the input. Find the TS
first (`task=optimize` with {ref}`saddle=1 <optimize.saddle>`), compute the Hessian there, check that it has exactly
one imaginary frequency and that this mode is the reaction you want, and only then run `task=irc`. An IRC started
from an unoptimized geometry gives two points with {ref}`back=0 <optimize.back>` and no curve with `back=1`.
<!-- src: 04 #92, #93, #100, #102 -->

### IRC stops with `Vicinity of a Stationary Point(?) --- STOP.`

On the first IRC step this means that the energy did not go down on that step. The reported fix is to change the
step size; see {ref}`radius <optimize.radius>`:

- on a very flat barrier top, increase the step so that it reaches the slope;
- on a very narrow barrier, such as a proton transfer, decrease it, because a step suited to heavy atoms throws the
  proton too far.

This advice comes from one experienced user. <!-- src: 04 #295, #298 --> <!-- verify -->

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
zero exact exchange, so the result was a pure-GGA-like calculation labelled as a hybrid. The author was told about
it and, according to a user who corresponded with him, did not intend to change it.
<!-- src: 03 §11 (sanya, amg); 04 #96, #99 -->

Newer builds (reported in 2014) refuse instead: the job prints `Basis set input:` twice and stops with
`application called MPI_Abort(MPI_COMM_WORLD, 1) - process 0`, before the summary box. Several users reproduced this.
<!-- src: 04 #307-#310 -->

**Fix.** Use `theory=ridft` for every hybrid functional. There is no hybrid TDDFT in Priroda.
<!-- src: 03 §11; 04 #310 -->

(troubleshooting.nan)=
### NaN energy, or an optimization that stops after one step

**Cause.** The SCF energy on the first step is not a number, so the optimizer stops at once and reports convergence.
The reported causes are all basis problems:

- **No basis for an element.** A molecule containing Bi was run with `3z.bas`, which covers only Z ≤ 54. Use
  `sbk.bas` (ECPs on every element) or `basis4.in` with {ref}`four=1 <control.four>`.
  <!-- src: 04 #334-#336 (Гесс, amge) -->
- **ECP not read.** In one case nothing was computed and there was no error message. The output showed zeros for one
  element in the basis table, and no sign that the ECP had been read. The cause was a defect in the user's basis file;
  `20+sbk.bas` worked. <!-- src: 04 #447-#451 -->
- A NaN at the first SCF iteration for [PtCl6]2- with the St-rsc-97 ECP basis went away after switching to the
  `sbk(u)` basis. Why that basis failed is not known. <!-- src: 04 #454, #455; 04 §21 -->

**What to check.** In the output, the ECP should be read before the basis, and every atom in the basis table should
have a non-zero number of basis functions.
<!-- src: 04 #448 (Гесс) -->

### TDDFT oscillator strengths are all zero

With `restrict=0`, singlet and triplet excitations get mixed. Use `restrict=1` and compute one multiplicity per run.
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
components do not sum to `E`. This is not an error: E = T + V + J + Ex + Ec + E(nn). The answer came from the author,
relayed by a user.
<!-- src: 04 #375, #382 (Laikov, relayed) -->

### Thermochemistry of single atoms

For a monoatomic species the enthalpy has an extra RT, and the rotational entropy is printed as `-inf`. Correct these
by hand and keep only the translational terms.
<!-- src: 03 §15 (Evgeniy, Llewule); 04 §0 -->

### Results depend on the number of processes

In one unstable TS search started from a poor guess, the optimization followed different paths with different
`-np`. Normally the results differ only in insignificant digits.
<!-- src: 03 §3 (amg, Nov 2008) -->

(troubleshooting.memory)=
## Memory, disk and scratch errors

All {ref}`$system <group.system>` limits apply per MPI process. With `disk=10` on four processes, up to 40 GB can be
used. <!-- src: 03 §3; keywords/system.yaml -->

### `malloc(...) failed`

**Cause.** Priroda could not allocate the memory requested in {ref}`memory <system.memory>`, plus any RAM disk
requested with a negative {ref}`disk <system.disk>`. The number in the message is the request in bytes.
<!-- src: 04 #58, #94, #463, #464 -->

**Fix.** Ask for less than the node really has free:

- With a RAM disk, `memory` plus |`disk`| (both in MB), times the number of processes, must fit in physical RAM.
  An example from a 24 GB node is `memory=9000 disk=-14000`. Several users confirmed this rule.
  <!-- src: 04 #462, #463, #468, #471 -->
- The 32-bit Windows (Cygwin) builds cannot allocate more than about 1 GB. 512 MB was enough for most DFT jobs.
  Several users confirmed this limit. The 64-bit Windows build with `cygwin1.dll` is reported to have no such limit.
  <!-- src: 04 #94, #95, #104, #105, #210, #211, #370 -->

A message beginning `We need 1.5 GB of memory...` was reported once. One reply guessed that it is about RAM
(`memory=`), not disk space, but this was not confirmed.
<!-- src: 04 #463, #464 --> <!-- verify -->

### `out of disk space`

**Symptom.** `0: out of disk space (VNNNN), <N>KB`, or a similar message naming another array, such as
`(ci.Rnvvo)`.

**Fix.**

- Raise {ref}`disk <system.disk>` above the amount reported. Remember that the value is per process. One user's
  correlated Hessian that ran out of disk on 16 processes then ran with `disk=40` on one fast drive.
  <!-- src: 03 §4; 04 #289, #290; 04 §19 -->
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
Both found that direct integrals avoid the problem:

```text
$integral direct=1 $end
```

See {ref}`direct <integral.direct>`. <!-- src: 05 §4.2 (EvgeniX, amge 2015) -->

### Where scratch files go

Priroda writes scratch files to the directory given by {ref}`path <system.path>`; if `path` is not set, to
`$TMPDIR`; otherwise to the directory of the input file. On a cluster, neither `/tmp` nor the input directory is
suitable for large scratch files: `/tmp` may sit on a quota-limited node. Use the cluster's local scratch area, or a
RAM disk with a negative `disk` value. Never put scratch on NFS.
<!-- src: 04 #462, #465; 06 §10 -->

A job that stops while writing a scratch file, with a message like
`0: write file /tmp/tmp9633.11 (leAX): fd=21 ...`, was reported once during an analytic Hessian and not answered.
A full scratch directory or a file-size limit is a plausible cause, but this is a guess; check the free space and the
`disk=` setting. <!-- src: 04 #460; 04 §17 (unverified inference) -->

If Priroda does not get enough memory or scratch, it stops with an error; it does not fall back to a slower
algorithm. <!-- src: 04 #199 -->

### Slow runs: disk speed

Priroda is very demanding of disk speed. For all methods except GGA DFT, the documentation warns that performance
degrades "terribly" if more than one process reads and writes large files on the same physical drive. Options, in order of
preference:

- keep scratch in RAM with a negative {ref}`disk <system.disk>` value (one cluster reported a 6× speed-up for
  RI-MP2);
- give each process its own physical drive with a colon-separated {ref}`path <system.path>` list;
- if the job is disk-bound, switch to direct integrals with {ref}`direct=1 <integral.direct>`. This costs CPU time but
  can be much faster overall: one RI-MP2 optimization went from 2 to 20 steps per night.
<!-- src: 04 #181, #192, #194, #293; 03 §3, §17; input.txt lines 39-41 -->

One user with 16 processes ignored the warning and put all scratch on one fast disk.
<!-- src: 04 #293 -->

(troubleshooting.parallel)=
## Parallel and MPI problems

### A parallel RI job hangs with no message

**Cause.** RI methods, RI-MP2 and RI-DFT included, hang forever if any process gets no work. This happens when the job
is too small for the number of processes. Two experienced users confirmed it and called it a bug.

**How to recognize it.** After `integral estimates`, the output lists the blocks per node. Look for a line with
`0 blocks`:

```text
    2892490 blocks,    103625770 integrals on node  0
    3681560 blocks,     91256706 integrals on node  1
```

**Fix.** Run small RI jobs on fewer processes, or on one core.
<!-- src: 05 §3.1 (EvgeniX, amge 2015) -->

Older reports describe similar hangs: small jobs on many processors hang (v6/v7); MP2 on a 102-atom complex died with
signal 8 on more than about 24 cores (v7, MVAPICH); a v6 Hessian on 4 cores could hang at `Solving for responses ...`.
The v6 advice was at most 2 cores for a Hessian and at most 4 for an optimization. Another user ran DFT, including
Hessians, on 24–32 cores without trouble, so this advice is disputed. Parallel runs work properly only from version
16 on.
<!-- src: 03 §3, §15 (Evgeniy, sanya); 04 #401 -->

### Little or no speed-up from more cores

- DFT scales well within one node but gains little beyond 6–8 cores: one user measured at most 10% more from 32
  cores than from 6–8. Another measured 101, 63 and 37 s for the same optimization on 8, 12 and 24 cores.
  <!-- src: 04 #343, #344 -->
- Running across several nodes gives no gain. Several experienced users report this.
  <!-- src: 04 #344, #417, #462 -->
- In a DFT run most of the memory and all the disk I/O stay on rank 0, so spreading a DFT job over nodes does not
  spread its memory. RI-MP2 distributes memory better.
  <!-- src: 03 §3 (v8 benchmarks); 04 #185, #343 -->
- For throughput, several single-core jobs at once can beat one multi-core job when the jobs are not disk-bound.
  <!-- src: 03 §3 (amg) -->
- For RI-MP2, the v5 documentation suggests a number of processes that divides the number of occupied orbitals.
  <!-- src: 06 §10 -->

### Starting a parallel run on Linux

The Priroda binary starts its own processes: run `./p -np 4 job.in job.out`. Starting it through the bundled
`mpiexec` failed with `Error in system call mpiexec: No such file or directory` or `mpiexec could not exec p`. Use
absolute paths for the binary, the input, the output and the basis file.
<!-- src: 04 #150, #152-#154 -->

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
Not every build on the author's site is reliable. A note there once said that the `w64/*.exe` 64-bit Cygwin builds
had a DFT/ECP bug. If a Windows build misbehaves, ask the author which build you should be running.
:::
<!-- src: 04 #366 -->
