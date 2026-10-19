(tasks.ts-irc-scan)=
# Transition states, IRC and scans

This chapter covers reaction paths: relaxed scans, transition-state (TS) searches, intrinsic reaction coordinate
(IRC) runs, and the little-documented tasks that take two structures. All of them are driven by the
{ref}`$optimize <group.optimize>` group. The keywords themselves are described in the reference; this chapter shows
how to combine them.

The examples use the isomerization HCN ⇄ HNC and the inversion of ammonia. Unless marked otherwise, they were run
on Priroda 25 (2025.02.28) with PBE and the `L1` set, and the output excerpts are copied from those runs.
<!-- src: 08 t24-t26, t37, t77a-h, t80c -->

## The route

A complete study of one elementary step takes six jobs:

1. **Relaxed scan** (`task=scan`) along a coordinate that describes the reaction, to get a rough TS geometry.
2. **Hessian** (`task=hessian`) at the highest point of the scan. It should have an imaginary frequency whose mode
   is the reaction.
3. **TS search**: `task=optimize` with {ref}`saddle=1 <optimize.saddle>`, with the Hessian of step 2 appended to the
   input as a `$Energy` group.
4. **Hessian at the TS**, to confirm exactly one imaginary frequency.
5. **IRC** (`task=irc`) from the TS with the Hessian of step 4 appended, run twice: once with
   {ref}`back=0 <optimize.back>` and once with `back=1`.
6. **Re-optimize both IRC endpoints** as ordinary minima.

```{graphviz}
:caption: The six jobs of a reaction-path study. Each arrow passes a geometry; the Hessian travels as a `$Energy` group.
:align: center

digraph route {
  rankdir=LR; bgcolor="transparent"; nodesep=0.3; ranksep=0.4;
  node [shape=box, style="rounded,filled", fillcolor="#e8f0e6", color="#2f5d3a", fontcolor="#1d2b20", fontsize=11, margin="0.15,0.07"];
  edge [color="#7d8f80", fontcolor="#7d8f80", fontsize=10, arrowsize=0.7];
  scan [label="1. task=scan\nhighest point"];
  h1   [label="2. task=hessian\none imaginary mode?"];
  ts   [label="3. task=optimize\nsaddle=1"];
  h2   [label="4. task=hessian\nexactly one imaginary"];
  irc0 [label="5. task=irc\nback=0"];
  irc1 [label="5. task=irc\nback=1"];
  min0 [label="6. optimize\nendpoint", fillcolor="#2f5d3a", fontcolor="white"];
  min1 [label="6. optimize\nendpoint", fillcolor="#2f5d3a", fontcolor="white"];
  scan -> h1 -> ts;
  ts -> h2;
  h2 -> irc0; h2 -> irc1;
  irc0 -> min0; irc1 -> min1;
}
```

<!-- src: 03 §9 (amg 2010 protocol); 04 #91, #92, #102, #314; 02 §5.5 (pri: hessian+saddle+hessian+irc); keywords/optimize.yaml saddle -->

Step 4 is not optional: users report that an IRC started without an accurate Hessian at a converged TS does not
work. If you already have a reasonable TS guess from intuition or another program, skip step 1.
<!-- src: 04 #92 (EvgeniX: "without 3.5, step 4 will not work"), #100, #102 -->

The Hessian is passed between jobs as text. Every Hessian run prints a `$Energy` group on lines prefixed with
`eng>`; strip the prefix and append the last such group to the next input, after `$molecule`. The command for this
is in {ref}`start.getting-started` (step 6); see also {ref}`$Energy <group.Energy>`. If an input holds several
`$Energy` groups, the last one is used, so don't leave an old one in the file.
<!-- src: 08 t25, t41, t41b; keywords/energy.yaml; docs/start/getting-started.md step 6 -->

All of these tasks ran in version 25 with `theory=` `dft`, `ridft`, `rimp2`, `ccsd`, `ccsd4t`, `tddft` and `qm_n3`.
<!-- src: 08 t66a-e, t67a-e, t68a-f, t80a-c -->

## Relaxed scans

### Input

A relaxed scan is a series of constrained optimizations. {ref}`fix <optimize.fix>` lists the internal coordinates to
constrain, five integers each (type, then four atom numbers padded with zeros: `1` distance, `2` angle, `3`
dihedral). {ref}`value <optimize.value>` gives the start values of **all** fixed coordinates, then the end values of
all of them, in Å and degrees. {ref}`points <optimize.points>` is the number of optimizations, both ends included.
<!-- src: input.txt via 04 #373; keywords/optimize.yaml fix, value, points; 08 t37 -->

This scan turns one H–N–H–H dihedral of ammonia from −180° to −150° in four points, with one N–H bond held at
1.1 Å throughout (its start and end values are equal):

```priroda
$system mem=256 disk=1 $end
$control
 task=scan
 theory=dft
 basis=/home/user/priroda/basis.in
$end
$optimize
 fix=1,1,2,0,0 3,2,1,4,3
 value=1.1,-180 1.1,-150
 points=4
 tol=1e-5
$end
$molecule
 charge=0 mult=1
 cartesian
 set=L1
   7    0.00000000    0.00000000    0.00000000
   1    0.00000000    0.00000000    1.00800000
   1    0.87295400    0.00000000   -0.50400000
   1   -0.87295400    0.00000000   -0.50400000
$end
```
<!-- src: tests/inputs/t37_scan.in, run as 08 t37 (adapted from the limor1 NH3_scan-fix example, 02 §4.2) -->

The program echoes each constraint with its start and end value:

```text
 constrained variable: type=1 i=  1 j=  2 k=  0 l=  0, value=    1.100000,     1.100000
 constrained variable: type=3 i=  2 j=  1 k=  4 l=  3, value= -180.000000,  -150.000000
```
<!-- src: 08 t80c output (same scan, points=3), verbatim -->

Point *k* of *N* lies at s = k/(N−1), and every scanned coordinate moves linearly from its start to its end value
with s. With `points=4` the points are s = 0, 1/3, 2/3 and 1.
<!-- src: 08 t37; 04 #373 (val example: 1.6 ... 2.0 in 5 points) -->

### Scanning two coordinates

Because all coordinates move together with one parameter s, giving two coordinates different start and end values
scans them **simultaneously**, along a straight line in the two-coordinate space, not over a grid. With
`value=1.0,-180 1.1,-150` in the example above, the N–H bond stretches from 1.0 to 1.1 Å while the dihedral turns.
<!-- src: 02 §4.3 (limor1 NH3_scan-scan, "simultaneous scan of two parameters"); 04 #373 -->

No source describes a scan over a two-dimensional grid. To map a surface, run one scan per value of the second coordinate,
fixing that coordinate with equal start and end values as for the N–H bond above.
<!-- src: no source describes a grid scan; this follows from the linear-scan rule above -->

### Reading the output

Each point is an ordinary constrained optimization and ends with `OPTIMIZATION CONVERGED in N steps!` and its
geometry on `MOL>` lines. After the last point the program repeats all of them under `Scan Structures:`, each as a
line with n, s and E followed by a `$molecule` group prefixed with `SCAN>`:

```text
 Scan Structures:
SCAN> n= 0, s=0.000000, E=   -56.40506567
SCAN>$molecule
SCAN> cartesian
SCAN> set=L1
SCAN>   7     0.00000000  -0.00000000  -0.03078317
SCAN>   1    -0.00000000   0.00000000   1.06921683
SCAN>   1     0.87258896  -0.00000000  -0.51921683
SCAN>   1    -0.87258896  -0.00000000  -0.51921683
SCAN>$end
```

The output ends with a table of E(s) and E(s) − E(0) and a rough text plot of the profile.
<!-- src: 08 t80c output (ccsd4t, points=3), verbatim; the SCAN summary format is the same in t37 and t68 -->

To list the points and pull out the geometry of point 1 as a ready `$molecule` group:

```bash
grep '^SCAN> n=' scan.out
awk -v n=1 '/^SCAN> n=/{p=($3==n",")} p&&/^SCAN>\$molecule/{q=1} q{print substr($0,6)} /^SCAN>\$end/{q=0}' scan.out
```
<!-- src: checked on the 08 t80c output -->

### From the scan maximum to a TS guess

The highest point of a scan is only a guess. A relaxed scan can overshoot the barrier and then jump to the other
side, so the highest point may be far from the TS and may have no imaginary frequency at all. Compute the Hessian
there and check it. The imaginary mode should be the reaction you want; if there is none, or if the imaginary mode
is something else (a methyl rotation, say), refine the scan or pick another guess.
<!-- src: 03 §9 (amg: highest scan point is not the TS, 9-phenylanthracene; "if the first imaginary frequency is not the right one, find another guess"); 04 #93 -->

For torsions about a double bond (AB C=D EF), a user recommends scanning the twist, the half-sum of the two
torsions A–C=D–E and B–C=D–F, rather than a single torsion: the TS lies near a twist of 90°, which is not the same as
one torsion at 90°. For a rotation with a symmetric profile, such as the rings of a ferrocene, the same user advises
scanning only to locate the TS and then getting the profile from an IRC.
<!-- src: 03 §9 (sanya, twisting/wagging); 04 #300 (amge, pentamethylferrocene) -->

### The dihedral sign

**Priroda's dihedral angles have the opposite sign to those of Molden, MOPAC, GAMESS and the IUPAC convention.**
A torsion of +100° in a Priroda Z-matrix is −100° in standard terms. When you take a dihedral value from another
program or a molecule viewer, flip its sign before putting it in `value=`. With the wrong sign, the first scan point
is the mirror image of the intended structure (for a chiral or twisted molecule), or a scrambled structure that has
nothing in common with the input geometry.
<!-- src: 08 t81i (Z-matrix +100 = IUPAC -100); 08 round-15 session scans (value=-100 gave the mirror image); 03 §8 (amg 2008, "all versions"; molden, mopac, gamess); 04 #271, #276, #278, #279 -->

Dihedral values read from a Priroda Z-matrix or Priroda output already have Priroda's sign. Check the first
`SCAN>` geometry against your input before trusting the rest of a scan.
<!-- src: 08 round-15 session scans (value=100 on the t81i Z-matrix molecule kept the structure) -->

## Transition-state search

### Input

A TS search is an ordinary optimization with {ref}`saddle=1 <optimize.saddle>` and a Hessian in the input. Here is
the HCN ⇄ HNC example. First a Hessian at a rough guess, with the hydrogen bridging C and N:

```priroda
$system mem=256 disk=1 $end
$control
 task=hessian
 theory=dft
 basis=/home/user/priroda/basis.in
$end
$molecule
 charge=0 mult=1
 cartesian
 set=L1
  6      0.000000    0.000000    0.000000
  7      0.000000    0.000000    1.190000
  1      1.132000    0.000000    0.366000
$end
```
<!-- src: tests/inputs/t77a_hcn_ts_guess_hessian.in, run as 08 t77a -->

It has one imaginary frequency, 1121.2i cm⁻¹. The TS input is the same with the task changed, an `$optimize` group
added, and the `$Energy` group of the Hessian run appended after `$molecule`:
<!-- src: 08 t77a -->

```priroda
$control
 task=optimize
 theory=dft
 basis=/home/user/priroda/basis.in
$end
$optimize saddle=1 steps=100 $end
```
<!-- src: tests/inputs/t77b_hcn_saddle.in, run as 08 t77b -->

### What the output confirms

Before the first step, the optimizer echoes its settings and reports the lowest eigenvalues of the Hessian it read:

```text
 Geometry optimization options:
 Coordinates: internal
 Tolerance on gradient       = 0.00010000
 Tolerance on displacement   = 0.01000000
 Trust radius                = 0.12500000 (max), 0.01562500 (min)
 Maximum number of steps     =        100
 Updated hessian used
 Saddle point search: follow = 1

 Geometry Optimization Step 0:
     9 cartesian,    3 internal coordinates
     3 independent variables
 include g
 Lowest eigenvalues: -0.33562  0.28349
 chosen: -0.33562
```
<!-- src: 08 t77b output, verbatim -->

Check three things here:

- `Saddle point search: follow = 1` shows that `saddle=1` was read.
- `Lowest eigenvalues:` with one negative value shows that the appended Hessian was read and has the right shape.
  If both values are positive, the Hessian is wrong for this geometry (in a test with the minimum's Hessian
  appended instead, the search ran all 128 steps without converging).
- `chosen:` names the eigenvalue whose eigenvector the search climbs.

<!-- src: 08 t25, t41b, t77b -->

The run ends like any optimization, with `OPTIMIZATION CONVERGED in 3 steps!` and the TS geometry on `MOL>` lines.
The step limits are those of an ordinary optimization: {ref}`trust <optimize.trust>`,
{ref}`steps <optimize.steps>` and {ref}`tolerance <optimize.tolerance>`. The sources give no TS-specific advice on
them.
<!-- src: 08 t77b -->

### Confirm one imaginary frequency

Run `task=hessian` at the converged TS. The frequency table marks imaginary frequencies with a trailing `i`:

```text
 | Mode | Freq.   | Mass.  | IR Int. |Raman A. |Raman D.| ROA (90)  | ROA (180) |
 *------*---------*--------*---------*---------*--------*-----------*-----------*
 |    1 | 1090.23i|   1.16 |  76.020 |   0.000 | 0.0000 |   0.00000 |   0.00000 |
```
<!-- src: 08 t77c output, verbatim -->

Exactly one imaginary frequency, whose mode (printed under `Normal Modes`, or viewed in Molden with
`print=+molden`) moves the atoms along the reaction, means a TS. Keep this output: its `$Energy` group is the input
Hessian for the IRC.
<!-- src: 03 §9; 04 #92, #93; 08 t77c -->

### Several imaginary frequencies

If the Hessian of the guess has more than one imaginary frequency, or the lowest one is not the reaction, the
search may climb the wrong mode. {ref}`follow <optimize.follow>` selects which Hessian eigenvector to follow (the
default is the first); check the `chosen:` line to see which one was taken. One user who followed a chosen mode reports
that it works best when the Hessian shows that mode clearly. Often the better fix is a better guess: refine the scan
near the maximum, or displace the geometry along the unwanted mode and recompute the Hessian.
<!-- src: input.txt (follow); Dft.rtf (default 1); 03 §9 (sanya: mode following with a chosen mode); 04 #93; 08 t77b (chosen line) -->
<!-- verify: only follow=1 was tested; whether follow=2 means the second-lowest eigenvalue is not confirmed -->

:::{note}
On very flat surfaces, such as a methyl rotation with a frequency of a few cm⁻¹, users warn that stationary points
may be artifacts, and that a stationary point found with one method can lie somewhere else entirely with another.
A scan is often more informative there than a TS search.
:::
<!-- src: 03 §8-9 (methyl rotation 5 cm-1, "may be artifacts, scan instead"); 04 #296 -->

## IRC

### Input

The IRC input holds the TS geometry (the `MOL>` group of the TS search) and the `$Energy` group of the Hessian at
the TS:

```priroda
$system mem=256 disk=1 $end
$control
 task=irc
 theory=dft
 basis=/home/user/priroda/basis.in
$end
$optimize points=30 back=0 $end
$molecule
 cartesian
 set=L1
   6    -0.38764722   0.00000000  -0.52922493
   7    -0.35863431   0.00000000   0.66492317
   1     0.74628153   0.00000000  -0.13569824
$end
```
<!-- src: tests/inputs/t77d_hcn_irc_rdefault_back0.in with the t77b geometry, run as 08 t77d; the $Energy group of t77c follows $end -->

Each run follows the path in one direction only. Run it a second time with `back=1` for the other direction.
{ref}`points <optimize.points>` is the maximum number of IRC points; the run stops earlier when it reaches a minimum.
In the HCN example 30 was enough: the halves took 19 and 21 points.
<!-- src: keywords/optimize.yaml back, points; 08 t26, t42, t77d, t77e -->

{ref}`radius <optimize.radius>` sets the step, in mass-weighted coordinates; adjacent points end up about twice
the radius apart. The default (0.1 in version 25) worked for both ammonia inversion and the hydrogen shift in HCN.
A smaller radius gives more points and a path that ends closer to the minimum, at higher cost; a larger one gives
fewer points and ends farther away. `Dft.rtf` gives an older default of 0.2.
<!-- src: keywords/optimize.yaml radius; 08 t26, t77d-h -->

### Reading the output

The header repeats the direction, the radius and the imaginary mode:

```text
 Intrinsic Reaction Coordinate
 -----------------------------
 n = 1, back = 0, down = 1
 r = 0.1000000000
 frequency = 1089.34i cm^-1:
```
<!-- src: 08 t77d output, verbatim -->

Point 0 is a single point at the TS. Every further point is a constrained optimization (`Constrained Optimization
for Path Point  N:`) that ends with `OPTIMIZATION CONVERGED` and prints the point's distance from the TS, energy and
gradient, then its geometry on `IRC>` lines:

```text
IRC> point   1: distance =   0.19448552 E =   -93.26282908 g = 0.00857678
IRC>$molecule
IRC> cartesian
IRC> set=L1
IRC>   6    -0.37714562   0.00000000  -0.52170012
IRC>   7    -0.36950686   0.00000000   0.66925190
IRC>   1     0.76111634   0.00000000  -0.21389325
IRC>$end
```
<!-- src: 08 t77d output, verbatim -->

With `back=1` the distances are negative. At the end the program prints `REACTION PATH:` and lists the points
again, ordered by distance, so the `back=1` list runs from the far end towards the TS.
<!-- src: 08 t42, t77e -->

### How an IRC ends

Two messages end a normal IRC:

- `Vicinity of a Stationary Point(?) --- STOP.`: the path has reached the region of a minimum (the gradient has
  become small).
- `Energy Minimum Passed --- STOP.`: the last point came out higher than the one before, so the path has stepped
  over the minimum. It often follows the `Vicinity` message.

```text
 Vicinity of a Stationary Point(?) --- STOP.
IRC> point  19: distance =   3.73559541 E =   -93.33987986 g = 0.00571851
...
 Energy Minimum Passed --- STOP.
```
<!-- src: 08 t26, t77d (verbatim, IRC geometry lines elided), t77e-h -->

The `Vicinity` message on the **first** step is not a normal end; see the pitfalls below. An IRC can also stop
before `points` is reached on a flat shelf or at another TS.
<!-- src: 04 #295, #298, #314 -->

:::{note}
In the version 25 test outputs, the point printed after a `Vicinity` stop was sometimes missing from the
`REACTION PATH:` list. Take endpoint geometries from the last `IRC>` groups before that list, not only from the list.
:::
<!-- src: 08 t77e output (point 21 printed after the STOP, list starts at 20); t77d list includes its last point -->

### Joining the two halves

The official site has a small shell script, `grx`, that copies the `REACTION PATH` sections of two IRC outputs
into one file:

```bash
sed -n '/REAC/,$p' irc_back1.out  > irc.txt
sed -n '/REAC/,$p' irc_back0.out >> irc.txt
```
<!-- src: 01 §8 (grx; it also refuses to overwrite and checks both files for REACTION PATH) -->

`grx irc_back1.out irc_back0.out irc.txt` does the same, after checking that both files contain `REACTION PATH`
and that `irc.txt` does not exist yet. Give the `back=1` output first: its list ends at the TS and the `back=0`
list starts there, so the joined file runs in order of distance from one minimum through the TS to the other
(point 0 appears twice).
<!-- src: 01 §8; order checked by joining the 08 t77e and t77d outputs -->

### Re-optimize the endpoints

An IRC ends near a minimum, not in it. Take the last `IRC>` geometry of each half and optimize it, best with
`task=optimize+hessian` so that the Hessian confirms a minimum. This extracts the last geometry:

```bash
sed -n '1,/REACTION PATH/p' irc_back0.out |
  awk '/^IRC>\$molecule/{b="";q=1} q{b=b substr($0,5) "\n"} /^IRC>\$end/{q=0} END{printf "%s",b}' > end0.mol
```
<!-- src: checked on the 08 t77d output -->

Put `end0.mol` in place of the `$molecule` group of an input with `task=optimize+hessian`, and do the same for the
`back=1` output.
<!-- src: 04 #313, #314 (always re-optimize); keywords/control.yaml (optimize+hessian) -->
<!-- verify -->

If an endpoint turns out to be another TS or a shelf, compute a Hessian there and run a new IRC from it.
<!-- src: 04 #314 -->

## Tasks that take two structures

Three tasks start from two `$molecule` groups, the start and the end structure, with the atoms numbered the same
way in both. They are hardly documented; treat them as experimental.
<!-- src: 03 §9 (amg, sanya, v9 banners); keywords/control.yaml task -->

| Task | What it does | Status |
|---|---|---|
| `saddle` | "Approximate Saddle Point Search": a one-dimensional maximization between the two structures, then a two-dimensional saddle search | Runs in version 25 |
| `transit` | "Synchronous Transit in Internal Coordinates" | Reported working in version 8; crashed in version 25 |
| `path` | "Minimum Energy Path Optimization" | No test and no usage report |

<!-- src: 03 §9; 08 t81c, t81d; keywords/control.yaml -->

For the two mirror images of pyramidal ammonia, `task=saddle` printed `Stage 1: One-Dimensional Maximization:`,
stopped at the planar midpoint (s = 0.5, E = −56.4876815, against −56.4877160 for the fully optimized TS), then
`Stage 2: Two-Dimensional Saddle Point Search:`, and ended normally. The input is two complete `$molecule` groups
after `$control`:
<!-- src: 08 t81c -->

```priroda
$system mem=256 disk=1 $end
$control
 task=saddle
 theory=dft
 basis=/home/user/priroda/basis.in
$end
$molecule
 charge=0 mult=1
 cartesian
 set=L1
  7    0.000000    0.000000    0.110000
  1    0.000000    0.940000   -0.260000
  1    0.814064   -0.470000   -0.260000
  1   -0.814064   -0.470000   -0.260000
$end
$molecule
 charge=0 mult=1
 cartesian
 set=L1
  7    0.000000    0.000000   -0.110000
  1    0.000000    0.940000    0.260000
  1    0.814064   -0.470000    0.260000
  1   -0.814064   -0.470000    0.260000
$end
```
<!-- src: tests/inputs/t81c_task_saddle_two_molecules.in, run as 08 t81c -->

Use the result as a TS guess and continue with a Hessian and `saddle=1` as above.

:::{warning}
`task=transit` with the same input printed the internal coordinates of both structures and then crashed with
`Bus error` in version 25. Users found it useful in version 8 for generating a TS guess when the reactive mode is
unclear, and found `task=saddle` about twice as fast on the same problem.
:::
<!-- src: 08 t81d; 03 §9 (sanya v8; amg: saddle same result about twice as fast) -->

Two further task names appear in older program banners: `conical` ("Conical intersection (0,1)") and `extremal`
("Calculation of Gradient Extremal Path", slow). Neither has been tested and no usage is reported; a forum question
about conical intersections in Priroda went unanswered.
<!-- src: 03 §5 (v9 banners); 04 #314 (extremal "not quite the same thing"; conical question unanswered); keywords/control.yaml -->

## Pitfalls

- **An IRC from a geometry that is not a converged TS** gives only a couple of points, or no path at all. Always run
  steps 3 and 4 of the route first.
- **`Vicinity of a Stationary Point(?)` on the first IRC step** means the energy did not go down on that step.
  Change {ref}`radius <optimize.radius>`: larger on a very flat barrier top, smaller on a narrow barrier such as a
  proton transfer.
- **A scan that starts from a mangled geometry** almost always has a dihedral with the wrong sign (see
  [](#the-dihedral-sign)).
- **TDDFT scans**: coordinates that are not fixed relax on the excited-state surface and can dissociate. In a
  version 25 test the excited-state iterations then gave `nan` and the run stopped; fixing all three N–H bonds made
  the same scan converge.
- **A Hessian from a different method or basis**: {ref}`gradient=0 <optimize.gradient>` is meant for this case.
  Version 25 TS searches with `ridft`, `rimp2`, `ccsd` and `tddft` converged from a DFT Hessian without it.
- **Two `task=` lines do not chain jobs**: version 25 runs only the last one. Run scan, Hessian, TS search and IRC as separate
  jobs.

<!-- src: 04 #100, #102; 04 #295, #298; 04 #271-#279; 08 t68d, t68f; input.txt (gradient); 08 t66a-d; 08 t81b -->

More on these problems is in {ref}`troubleshooting.optimization` and the IRC sections that follow it in
{doc}`../troubleshooting/common-problems`.
