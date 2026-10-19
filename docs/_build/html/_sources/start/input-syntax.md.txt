# Input syntax

`input.txt` describes the input as "a kind of NAMELIST free format". It is close to the GAMESS-US format: keywords are
grouped, and each group starts with `$name` and ends with `$end`. This chapter covers the rules that apply to all
groups. The individual keywords are in the {doc}`input reference <../reference/index>`.
<!-- src: input.txt; 06 §2 -->

A complete input for an NH3 optimization, adapted from the KNC wiki FAQ:

```priroda
$system mem=512 disk=-512 path=/tmp $end
$control
 task=optimize
 theory=dft
 basis=/opt/priroda/basis.in
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

<!-- src: 06 §2 (FAQ example 1; basis file and set changed to the current basis.in/L1); run as printed on v25 (08 t58a) -->

## Groups

A group starts with `$` followed by the group name and ends with `$end`. It may sit on one line or span several:

```priroda
$scf conv=1e-7 $end

$scf
 procedure=bfgs
 convergence=1e-7
$end
```
<!-- src: 08 t04; 08 (review check: conv=1e-7 alone, procedure before and after convergence) -->


Inside a group, `keyword=value` pairs are separated by spaces or line breaks, and several pairs can share a line
(`theory=qm_n3 basis=qm.in`). Blank lines inside a group are allowed.
<!-- src: input.txt; 01 §4.2; 02 §3; 05 §5 -->

The order of the groups does not matter, and neither does the order of keywords within a group. The exception is
`$molecule`, whose contents are ordered data. (The KNC wiki FAQ also lists `$Energy`, but version 25 reads it with
the same keyword reader as the other groups.)
<!-- src: 06 §2; 09 (energy read by the generic namelist reader; only $molecule by mol_input) -->


Groups you do not need can be left out; most keywords have sensible defaults. `input.txt` advises changing only what
the problem requires.
<!-- src: input.txt; 06 §2 -->

Two groups can also share a line: `$scf conv=1e-7,1e-3 $end $grid acc=1e-9 $end` sets both values in version 25.
Inputs in the sources normally start each group on a new line, which is easier to read.
<!-- src: 08 t04 -->

## Keywords

### Case

Group names, keyword names and keyword values are case-insensitive: `$System` and `$system`, `theory=riDFT` and
`theory=ridft`, `functional=pbe` and `functional=PBE` are the same. File names are the exception, because Linux file
names are case-sensitive. This applies to `basis=`, `save=`, `path=` and other file names, such as `file=` in
`$dynamic` and `$uniq`.
<!-- src: 06 §2, §3 ($System); 05 §5; 01 §4.8, §4.9, §4.11 -->

### Abbreviations

Within a group, a keyword can be shortened to a prefix. The example in `input.txt` is `mem` for `memory`. Inputs in the
sources use, among others:
<!-- src: input.txt; 06 §2 -->

| Short form | Keyword |
|---|---|
| `mem=` | {ref}`$system memory <system.memory>` |
| `conv=`, `iter=`, `proc=` | {ref}`$scf convergence <scf.convergence>`, {ref}`iterations <scf.iterations>`, {ref}`procedure <scf.procedure>` |
| `func=` | {ref}`$dft functional <dft.functional>` |
| `acc=`, `accur=` | {ref}`$grid accuracy <grid.accuracy>` |
| `tol=`, `cart=`, `val=` | {ref}`$optimize tolerance <optimize.tolerance>`, {ref}`cartesian <optimize.cartesian>`, {ref}`value <optimize.value>` |
| `disp=` | {ref}`$d2edr2 displace <d2edr2.displace>` |
| `nuc=` | {ref}`$control nucleus <control.nucleus>` |
| `rout=` | {ref}`$integral routine <integral.routine>` |

<!-- src: 06 §2; 01 §4; 03 §5; 04 #376 -->

Keywords belong to their group. The same name can mean different things in different groups: `steps` in
{ref}`$optimize <optimize.steps>` is the maximum number of optimization cycles, while `steps` in
{ref}`$d2edr2 <d2edr2.steps>` selects displacement steps of a numerical Hessian.

A prefix must stay unambiguous within its group. In `$scf`, `co` matches both `convergence` and `core`; in version 25,
`$scf co=1e-7 $end` stopped with `unknown name e-7`, a message that does not point to the cause. In inputs you keep
or share, prefer the full keyword names; they are also easier to search for.
<!-- src: 09 ($scf names); 08 (review check: co=1e-7); input.txt -->

Do not give the same keyword twice in one group, even in different spellings. In version 6, an `$optimize` group with
both `step=` and `steps=` took the maximum number of steps from `step`.
<!-- src: 03 §8 (v6 step/steps, Evgeniy) -->

A misspelled or unknown keyword name stops the run right after the basis-set echo, with a message naming the group
and the keyword:

```text
*** error in '$scf' : unknown name nosuchkeyword
```
<!-- src: 08 t06 (verbatim) -->

Only groups that the task reads are checked. In version 25, an unknown keyword in `$optimize` stopped an
optimization (`unknown name coordinated`) but was ignored in an energy run, which does not read `$optimize`. A
clean energy run therefore does not prove that the rest of the input is correct.
<!-- src: 08 t40, t40b, t40c -->

The same message can appear for a keyword you spelled correctly. In version 25, a one-value `convergence=` followed
by `iterations=` in `$scf` stops the run with `unknown name terations` (or `erations`): the name of `iterations` is
cut short. Give `convergence` both of its values (`convergence=1e-6,1e-3`), or put it last in the group; see
{ref}`troubleshooting.scf-parser`.
<!-- src: 05 §5.1; 08 t07a, t07b, t22a-c; 08 (review check: convergence value series, iter=, n1=, other keywords); slurm s02-s04 first attempt (erations with 1e-10) -->


## Values

Scalars
: Integers (`steps=100`), reals in plain or exponent notation (`trust=0.2`, `tol=1e-5`) and words
  (`task=optimize`). A sign is allowed: `charge=+1`.
  <!-- src: input.txt; 05 §5 -->

Lists
: Values separated by commas, for keywords that take several numbers: `tol=1e-5,1e-4`, `mem=2048,256`,
  `temperature=203, 223, 248, 298`. Spaces after the commas are allowed, and some lists are also written with spaces
  between groups of values (`fix=1,1,2,0,0 3,2,1,4,3`). If you give fewer values than the keyword holds, the rest
  keep their defaults: `$scf conv=1e-10` sets only the SCF threshold and leaves the CP-SCF threshold at `1e-3`.
  <!-- src: input.txt; 05 §5; 02 §3; 01 §4.6 -->

Indexed arrays
: `name(i)=a,b,…` assigns values to an array starting at element *i* and leaves the other elements unchanged.
  `$guess na(85)=86,85 $end` sets element 85 of `na` to 86 and element 86 to 85, which swaps two orbitals. The same
  form is used for {ref}`$optimize value <optimize.value>` (`val(5)=2.0,2.1`),
  {ref}`$nmr standard <nmr.standard>` (`standard(6)=181.9921`) and {ref}`$atoms core <atoms.core>`.
  <!-- src: input.txt; 04 #373 -->

Flag strings
: {ref}`$control print <control.print>` takes a string of options, each switched on with `+` or off with `-`:
  `print=+vectors+molden`, `print=-internals+molden`. The leading `+` may be omitted (`print=charges+bonds`).
  <!-- src: input.txt; 06 §3; 04 #460 -->

Quoted strings
: A file name or path may be put in double quotes. The quotes are optional: `basis="3z.bas"` and `basis=basis.in`
  both work, as does `path="/scratch/priroda"`. Use the straight ASCII double quote `"`. Typographic quotes
  break the name, and two single quotes do not count as a double quote: `basis=''3z.bas''` fails with
  `error opening file ''3z.bas''`. Avoid spaces and non-ASCII characters in file names, directory names and the
  host name.
  <!-- src: input.txt; 03 §2 (amg: no Cyrillic or spaces), §5; 05 §5; 04 #64 -->

## The `$molecule` group

{ref}`$molecule <group.molecule>` is read as ordered data rather than as keyword pairs:

1. `charge=` and `mult=` (spin multiplicity 2S+1), both optional, with defaults 0 and 1;
2. one of the words `cartesian` or `z-matrix`;
3. one line per atom, optionally preceded by `set=` lines that choose the basis set for the atoms that follow.

The first items may share the opening line:

```priroda
$molecule charge=0 mult=1 cartesian
 set=L1
  8    0.000000    0.000000    0.117300
  1    0.000000    0.757200   -0.469200
  1    0.000000   -0.757200   -0.469200
$end
```

<!-- src: input.txt; 03 §5 (working inputs); 05 §5; 08 t58b -->

Each atom line begins with the atomic number written as an integer. Cartesian coordinates are in Å unless `unit=b` is
given. The Z-matrix forms, mixed Cartesian and Z-matrix input, isotope masses and per-atom basis sets are described
in the {ref}`$molecule <group.molecule>` reference.
<!-- src: input.txt; 01 §4.7 -->

### Several `$molecule` blocks

Some tasks read more than one `$molecule` group from one input:

- `task=transit`, `task=saddle` and `task=path` take two blocks, the start and the end structure. The atoms must be
  numbered the same way in both. `task=saddle` is not the same as {ref}`$optimize saddle=1 <optimize.saddle>`, the
  transition-state search from a stored Hessian. In a version 25 test, `task=saddle` with the two mirror-image
  structures of ammonia ran a two-stage search (a one-dimensional maximization between the structures, then a
  two-dimensional saddle search) and stopped at the planar midpoint, 0.00003 hartree above the fully optimized
  transition state. `task=transit` with the same input crashed with a bus error after printing its internal
  coordinates. `task=path` was not tested.
- `task=uniq` takes any number of blocks and filters out duplicate structures; the official example has 157.

These tasks are undocumented; see {ref}`$control task <control.task>` and {ref}`$uniq <group.uniq>`.
<!-- src: 03 §5, §9; 01 §4.9; 09 (task names exist in v25); 08 t81c, t81d (task=uniq: 08 review check) -->

## Text outside groups

Everything outside a `$name … $end` group is ignored. There is no documented comment character, but this rule serves
the same purpose, and the official example inputs use it to switch input off:
<!-- src: 01 §4, §10; 03 §5 (amg: trailing Energy line has no effect) -->

- **Delete the `$`** to disable a whole group. `integral dir=1 $end` in the official 2023–2025 example inputs is plain text,
  not an `$integral` group.
- **Move keywords after `$end`** to disable them. In the example below, `v=` and `h=` are outside `$dynamic` and
  have no effect.
- **Keep notes after `$end`.** Helper scripts append result lines such as `Energy = …` after the `$molecule` group,
  where they do no harm.

```priroda
integral dir=1 $end
$dynamic
 e=0.001
 d=0.03
 n=1000,100
$end
 v=500.0
 h=0.1
$molecule charge=0 mult=1 cartesian
 set=L1
  8    0.000000    0.000000    0.117300
  1    0.000000    0.757200   -0.469200
  1    0.000000   -0.757200   -0.469200
$end
 Energy =   -76.36539137
```

<!-- src: 01 §4, §4.8, §4.9 (pattern of the official example inputs; atoms and energy replaced by the water of 08 t01); 08 t81e, t81f (tested in a short task=thermostat run: v and h after $end are not echoed, inside $dynamic they are) -->


In version 25 a line of text before the first group and a disabled group with its leftover `$end`
(`integral dir=1 $end`) are both ignored: the result is identical to the same input without them. Text inside a
group is parsed as keywords, so do not put notes there.
<!-- src: 08 t05 -->

A group opened with `&` instead of `$` is ignored like any other text: in version 25, `&dft func=BLYP $end` left the
functional at PBE, with no message. Always use `$`.
<!-- src: 04 #376; 08 t23 -->

## Appending results of earlier runs

Priroda writes reusable results into the main output file. Each such line carries a prefix, for
example `eng>` or `num>`. Strip the prefix and append the lines to the next input. The program has no separate
restart file for these data; SCF orbitals are the exception, saved with {ref}`$control save <control.save>`.
<!-- src: 06 §4 -->

### `$Energy` from `eng>` lines

A run prints its energy and dipole, plus the gradient when one is computed and, after `task=hessian`, the Hessian, as
an {ref}`$Energy <group.Energy>` group on lines prefixed with `eng>`:

```text
eng>$Energy
eng> E=-2.894457077327e+04
eng> D= 0.00000000e+00  0.00000000e+00  0.00000000e+00
eng> G= 3.53877831e-09  1.65504544e-08 -3.64771621e-07
eng>   -1.31128901e-07 -6.73350427e-09 -2.19780956e-06
eng>    1.27590122e-07 -9.81695012e-09  2.56258122e-06
eng>$end
```

<!-- src: 06 §4; 08 t01 (task=energy prints only E= and D=) -->

To reuse it, remove the prefix and append the block to the end of the next input, after `$molecule`:

```bash
sed -n 's/^eng>//p' mol.out >> mol.in
```

The `ge` script on the official site does the same. When the output contains a `NUMERICAL AND ANALYTICAL GRADIENT`
section, it ignores everything before that section.
<!-- src: 01 §8; 03 §8 (perl one-liner); 03 §14 -->

:::{warning}
An optimization prints an `eng>` block at every step, and the command above appends all of them. Append only the
block you need, normally the one from a `task=hessian` run. If the input holds several `$Energy` groups, the
program uses the **last** one, even when an earlier one matches the geometry.
:::
<!-- src: 01 §7 (one eng block per optimization step); 08 t41, t41b -->

A stored Hessian is required by {ref}`$optimize saddle=1 <optimize.saddle>` and `task=irc`. It also helps difficult
minimizations, and it lets you redo the vibrational analysis or the thermochemistry without recomputing.
<!-- src: Dft.rtf lines 79, 103; 06 §4, §5; 08 t25, t26, t66 -->

### `num>` lines

Partial results of a numerical calculation are printed on lines prefixed with `num>`. There are two uses:

- A numerical Hessian split over several runs with {ref}`$d2edr2 steps <d2edr2.steps>`. Collect the `num>` lines of
  all partial outputs into one input, add `$d2edr2 steps=-1 $end`, and run once more:

  ```bash
  grep -h "^num>" mol.out1 mol.out2 mol.out3 mol.out4 | sed 's/^num>//' >> mol.in
  ```

  The lines hold numbered `$Energy000`, `$Energy001`, … groups, one per displaced geometry. The combining run does
  no SCF of its own. The command given in `input.txt`, `sed "s/\.*num>//g"`, leaves the file names that `grep` adds
  for several files at the start of each line; use `grep -h` as above.
- Raman intensities. A `task=dipole` run writes `num>` lines; append them to the input of a `task=hessian` run, and
  the `Raman A.` and `Raman D.` columns of the frequency table are filled in.

<!-- src: input.txt; 03 §10; 04 #381; 08 t55, t56 (both workflows checked on v25; the input.txt sed leaves file names) -->

### Optimized geometry from `MOL>` lines

After `OPTIMIZATION CONVERGED`, the final geometry is printed as a ready-made `$molecule` group on lines prefixed with
`MOL>`. Strip the prefix to continue from that geometry. The `gm` script on the official site replaces the `$molecule`
group of the input with it. Because `gm` replaces everything from `$molecule` to the end of the file, keep
`$molecule` as the last group of your inputs. Anything appended after it, including an `$Energy` group with a
Hessian, is deleted by `gm`; append such blocks again afterwards.
<!-- src: 01 §7, §8 (gm: sed stops at $molecule); 06 §4 -->

An optimization that runs out of steps prints no `MOL>` lines in version 25. The geometry of each step is printed on
lines prefixed with lowercase `mol>`; the block from the last step is the geometry to restart from. `gm` finds
neither `MOL>` lines nor an input echo in such an output and stops with `mol?`, so strip the last `mol>` block by
hand.
<!-- src: 08 t12 (two steps, two mol blocks, no MOL lines, no input echo; checked in the round 1-3 output); 01 §8 (gm script) -->

## Common mistakes

Non-integer atomic numbers
: `25.0` or `8.0` instead of `25` or `8` in `$molecule`. The atom lines are read as a stream of numbers, so the
  rest of the group shifts. In version 25 this gives no error at all: water written with `8.0` and `1.0` ran as an
  oxygen atom plus three empty centres with Z=0, and printed a meaningless energy. Older versions were reported to
  stop with `illegal charge/multiplicity`. Check the `formula:` line near the top of the output. Element symbols
  are not accepted either: in version 25, water written with `O` and `H` stopped after `molecule input: ''` with the
  line `'o' ?`.
  <!-- src: 03 §5; 08 t09; 08 (review check: element symbols) -->

Typographic quotes
: Word processors and some web pages turn `"` into curly or angle quotes, which break file names in `basis=` and
  `path=`. Retype them as straight quotes.
  <!-- src: 04 #64 -->

Two `task=` lines
: A second `task=` line does not start a second job. In version 25 the last one wins: with `task=optimize` and then
  `task=hessian` in `$control`, only the Hessian was computed, and nothing was printed about the first line. In version 6
  users reported that only the first task ran. `task=optimize+hessian` is the only combination the program
  understands. Run other sequences as separate jobs.
  <!-- src: 04 #69, #70 (v6; optimize+hessian "not in all versions"); 09 (optimize+hessian is one task name in v25); 08 t81b -->


Windows line endings (CRLF)
: The run stops in `$molecule` with `molecule input: ''` followed by a garbled `' ?matrix` or `?rtesian`. Convert the
  file with `dos2unix`; see {doc}`running`.
  <!-- src: 04 #63-#65 -->

Misspelled task or theory name
: Gives no error. An unknown `task=` value sets up the run and stops quietly after the SCF and grid settings; an
  unknown `theory=` value runs Hartree–Fock, with the misspelled name in the summary box. Check the
  `Theoretical Method` line and that the output goes on to an SCF.
  <!-- src: 08 t50, t50b -->

Hybrid functional without `theory=ridft`
: With `theory=dft` version 25 stops with no message; with `theory=tddft` it silently drops the exact exchange. See
  {ref}`troubleshooting.hybrid`.
  <!-- src: 04 #96, #310; 08 t08, t46 -->

`basis4.in` without `four=1`
: The relativistic basis file needs `four=1` in `$control`. Without it, version 25 stops right after the line
  `Basis set input:` with the single line `1?`.
  <!-- src: 04 #207, #208; 08 t49 -->

More input problems, with their exact error messages, are listed in {ref}`troubleshooting.input`.
