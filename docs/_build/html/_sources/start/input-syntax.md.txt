# Input syntax

`input.txt` describes the input as "a kind of NAMELIST free format". It is close to the GAMESS-US format: keywords are
grouped, and each group starts with `$name` and ends with `$end`. This chapter covers the rules that apply to all
groups. The individual keywords are in the {doc}`input reference <../reference/index>`.
<!-- src: input.txt; 06 §2 -->

A complete input for an NH3 optimization, adapted from the KNC wiki FAQ:

```text
$system mem=512 disk=-512 path=/tmp $end
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

<!-- src: 06 §2 (FAQ example 1; basis file and set changed to the current basis.in/L1) --> <!-- verify -->

## Groups

A group starts with `$` followed by the group name and ends with `$end`. It may sit on one line or span several:

```text
$scf conv=1e-7 $end

$scf
 convergence=1e-7
 procedure=bfgs
$end
```

Inside a group, `keyword=value` pairs are separated by spaces or line breaks, and several pairs can share a line
(`theory=qm_n3 basis=qm.in`). Blank lines inside a group are allowed.
<!-- src: input.txt; 01 §4.2; 02 §3; 05 §5 -->

The order of the groups does not matter, and neither does the order of keywords within a group. The exceptions are
`$molecule` and `$Energy`, whose contents are ordered data.
<!-- src: 06 §2 -->

Groups you do not need can be left out; most keywords have sensible defaults. `input.txt` advises changing only what
the problem requires.
<!-- src: input.txt; 06 §2 -->

Two groups can also share a line: `$scf conv=1e-7 $end $grid acc=1e-9 $end` sets both values in version 25. Every
input in the sources starts each group on a new line, which is easier to read.
<!-- src: 08 t04 -->

## Keywords

### Case

Group names, keyword names and keyword values are case-insensitive: `$System` and `$system`, `theory=riDFT` and
`theory=ridft`, `functional=pbe` and `functional=PBE` are the same. File names are the exception, because Linux file
names are case-sensitive. This applies to `basis=`, `save=` and `path=`.
<!-- src: 06 §2, §3 ($System); 05 §5; 01 §4.11 -->

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

:::{warning}
A prefix must stay unambiguous within its group. How Priroda resolves a prefix that matches two keywords is not
documented. In version 6, when `$optimize` contained both `step=` and `steps=`, the maximum number of steps was taken
from `step`. In inputs you keep or share, prefer the full keyword names; they are also easier to search for.
:::
<!-- src: 03 §8 (v6 step/steps); input.txt -->

A misspelled or unknown keyword name stops the run right after the basis-set echo, with a message naming the group
and the keyword:

```text
*** error in '$scf' : unknown name nosuchkeyword
```
<!-- src: 08 t06 (verbatim) -->

The same message can appear for a keyword you spelled correctly. In version 25,
`$scf convergence=1e-7 iterations=250 $end` stops with `unknown name terations`: the value list of `convergence`
takes the first letter of the next keyword. Put another keyword between the two, or see
{ref}`$scf convergence <scf.convergence>`.
<!-- src: 05 §5.1; 08 t07a, t07b -->

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
: A file name or path may be put in double quotes, and must be if it contains special characters:
  `basis="3z.bas"`, `path="/home/user/priroda/scratch"`. Use the straight ASCII double quote `"`. Typographic quotes
  break the name, and two single quotes do not count as a double quote: `basis=''3z.bas''` fails with
  `error opening file ''3z.bas''`.
  <!-- src: input.txt; 03 §2, §5; 04 #64 -->

## The `$molecule` group

{ref}`$molecule <group.molecule>` is read as ordered data rather than as keyword pairs:

1. `charge=` and `mult=` (spin multiplicity 2S+1), both optional, with defaults 0 and 1;
2. one of the words `cartesian` or `z-matrix`;
3. one line per atom, optionally preceded by `set=` lines that choose the basis set for the atoms that follow.

The first items may share the opening line:

```text
$molecule charge=0 mult=1 cartesian
 set=L1
  8    0.000000    0.000000    0.117300
  1    0.000000    0.757200   -0.469200
  1    0.000000   -0.757200   -0.469200
$end
```

<!-- src: input.txt; 03 §5 (working inputs); 05 §5 --> <!-- verify -->

Each atom line begins with the atomic number written as an integer. Cartesian coordinates are in Å unless `unit=b` is
given. The Z-matrix forms, mixed Cartesian and Z-matrix input, isotope masses and per-atom basis sets are described
in the {ref}`$molecule <group.molecule>` reference.
<!-- src: input.txt; 01 §4.7 -->

### Several `$molecule` blocks

Some tasks read more than one `$molecule` group from one input:

- `task=transit`, `task=saddle` and `task=path` take two blocks, the start and the end structure. The atoms must be
  numbered the same way in both.
- `task=uniq` takes any number of blocks and filters out duplicate structures; the official example has 157.

These tasks are undocumented; see {ref}`$control task <control.task>` and {ref}`$uniq <group.uniq>`.
<!-- src: 03 §5, §9; 01 §4.9 -->

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

```text
integral dir=1 $end
$dynamic
 e=0.001
 d=0.03
 n=1000,100
$end
 v=500.0
 h=0.1
$molecule
 ...
$end
 Energy =   -783.83738426
```

<!-- src: 01 §4, §4.8, §4.9 -->

In version 25 a line of text before the first group and a disabled group with its leftover `$end`
(`integral dir=1 $end`) are both ignored: the result is identical to the same input without them. Text inside a
group is parsed as keywords, so do not put notes there.
<!-- src: 08 t05 -->

A group opened with `&` instead of `$` is ignored like any other text: in version 25, `&dft func=BLYP $end` left the
functional at PBE, with no message. Always use `$`.
<!-- src: 04 #376; 08 t23 -->

## Appending results of earlier runs

Priroda writes results that can be reused as input into the main output file. Each such line carries a prefix, for
example `eng>` or `num>`. Strip the prefix and append the lines to the next input. The program has no separate
restart file for these data; SCF orbitals are the exception, saved with {ref}`$control save <control.save>`.
<!-- src: 06 §4 -->

### `$Energy` from `eng>` lines

A run prints its energy, dipole, gradient and, after `task=hessian`, the Hessian as an
{ref}`$Energy <group.Energy>` group on lines prefixed with `eng>`:

```text
eng>$Energy
eng> E=-2.894457077327e+04
eng> D= 0.00000000e+00  0.00000000e+00  0.00000000e+00
eng> G= 3.53877831e-09  1.65504544e-08 -3.64771621e-07
eng>   -1.31128901e-07 -6.73350427e-09 -2.19780956e-06
eng>    1.27590122e-07 -9.81695012e-09  2.56258122e-06
eng>$end
```

<!-- src: 06 §4 -->

To reuse it, remove the prefix and append the block to the end of the next input, after `$molecule`:

```text
sed -n 's/^eng>//p' mol.out >> mol.in
```

The `ge` script on the official site does the same. It also skips the first block when the output contains a
`NUMERICAL AND ANALYTICAL GRADIENT` section.
<!-- src: 01 §8; 03 §8 (perl one-liner); 03 §14 -->

:::{warning}
An optimization prints an `eng>` block at every step, and the command above appends all of them. Append only the
block you need, normally the one from a `task=hessian` run. It is not documented what the program does with several
`$Energy` groups in one input.
:::
<!-- src: 01 §7 (one eng block per optimization step) --> <!-- verify -->

A stored Hessian is required by {ref}`$optimize saddle=1 <optimize.saddle>` and `task=irc`. It also helps difficult
minimizations, and it lets you redo the vibrational analysis or the thermochemistry without recomputing.
<!-- src: Dft.rtf; 06 §4, §5; energy.yaml -->

### `num>` lines

Partial results of a numerical calculation are printed on lines prefixed with `num>`. There are two uses:

- A numerical Hessian split over several runs with {ref}`$d2edr2 steps <d2edr2.steps>`. Collect the `num>` lines of
  all partial outputs into one input, add `$d2edr2 steps=-1 $end`, and run once more:

  ```text
  grep "num>" mol.out{1,2,3,4} | sed "s/\.*num>//g" >> mol.in
  ```

  The `sed` expression also removes the file-name prefix that `grep` adds for several files.
- Raman intensities. A `task=dipole` run writes `num>` lines; append them to the input of a `task=hessian` run.

<!-- src: input.txt; 03 §10; 04 #381 -->

### Optimized geometry from `MOL>` lines

After `OPTIMIZATION CONVERGED`, the final geometry is printed as a ready-made `$molecule` group on lines prefixed with
`MOL>`. Strip the prefix to continue from that geometry. The `gm` script on the official site replaces the `$molecule`
group of the input with it. Because `gm` replaces everything from `$molecule` to the end of the file, keep
`$molecule` as the last group of your inputs, followed only by appended result blocks.
<!-- src: 01 §7, §8; 06 §4 -->

## Common mistakes

Non-integer atomic numbers
: `25.0` or `8.0` instead of `25` or `8` in `$molecule`. The atom lines are read as a stream of numbers, so the
  rest of the group shifts. In version 25 this gives no error at all: water written with `8.0` and `1.0` ran as an
  oxygen atom plus three empty centres with Z=0, and printed a meaningless energy. Older versions were reported to
  stop with `illegal charge/multiplicity`. Check the `formula:` line near the top of the output. Element symbols
  (`O`) are not accepted either.
  <!-- src: 03 §5; molecule.yaml; 08 t09 -->

Typographic quotes
: Word processors and some web pages turn `"` into curly or angle quotes, which break file names in `basis=` and
  `path=`. Retype them as straight quotes.
  <!-- src: 04 #64 -->

Two `task=` lines
: A second `task=` line does not start a second job; only the first task runs. `task=optimize+hessian` is the only
  combination the program understands. Run other sequences as separate jobs.
  <!-- src: 04 #69, #70 -->

Windows line endings (CRLF)
: The run stops in `$molecule` with `molecule input: ''` followed by a garbled `' ?matrix` or `?rtesian`. Convert the
  file with `dos2unix`; see {doc}`running`.
  <!-- src: 04 #63-#65 -->

Hybrid functional without `theory=ridft`
: Older versions ran a pure GGA; version 25 stops after the basis-set echo with no message. See
  {ref}`$control theory <control.theory>`.
  <!-- src: 04 #96, #310; 08 t08 -->

`basis4.in` without `four=1`
: The relativistic basis file needs `four=1` in `$control`.
  <!-- src: 04 #207, #208 -->

More input problems, with their exact error messages, are listed in {ref}`troubleshooting.input`.
