# Installing and running

Priroda has no installer. You copy an executable, the basis-set files you need and, for parallel runs, the MPI
launcher into a directory, write an input file, and start the program with the input and output file names as
arguments.

(obtaining-priroda)=
## Obtaining Priroda

Priroda is free of charge. The executables, the basis-set files and the helper scripts can be downloaded from the
official site, <https://rad.chem.msu.ru/~laikov/p_w/>. Only parallel runs on Windows need more: an MPI runtime, which
is not on the site (see {ref}`running-windows-parallel`). Put the executable and `basis.in` in a directory of your
own. The main Linux executable, `p`, is probably statically linked (see {ref}`executables`). The page is a bare file
index with no documentation, license text or contact information. It holds:

- Linux x86-64 executables (`p`, `p4`, `p_d`, `p4_d`), builds for particular clusters (`p_l`, `p_mvs1p1`, `p_mvs10p`,
  `p_mvs10q`), an ARM build (`p_arm`), a bundled `mpiexec`, and the molecule viewer `xm`;
- Windows (Cygwin, x86-64) executables in `exe64/`;
- example inputs and outputs;
- basis-set and parameter files (`basis.in`, `basis4.in`, `b2*.in`, `b4s*.in`, `3z.bas`, `sbk.bas`, `qm.in`);
- small shell scripts: `ge` (append the `$Energy` block from an output to the input), `gm` (replace `$molecule` with
  the optimized geometry) and `grx` (join two IRC halves).
<!-- src: 01 §2.1, §2.2, §2.5, §8; 04 #503 -->

Which executable to choose is described under {ref}`executables` below.

Users have also obtained the program by writing to the developer, Dimitri Laikov, by e-mail. Users reported the
address `dimitri_laikov@mail.ru` from 2010 to 2018; earlier it was `laikov@physto.se`. Users note that he does not
always answer quickly.
<!-- src: 04 #2, #121, #287, #377, #406; 03 §1 -->

:::{note}
The legal status is not stated on the official site. A 2009 presentation relayed on a forum said that Priroda is
registered with Rospatent and distributed through the company OOO "Dimonta". A user reported in 2018 that the developer
had said, a couple of years earlier, that there was no licence agreement. Users customarily ask the developer's
permission before using the program.
:::
<!-- src: 03 §1; 04 #2, #404, #443-#445 -->

The official site has hosted builds with known defects. In 2016 it carried a note that the `w64/*.exe` builds (an
attempt at 64-bit Cygwin) had a DFT/ECP bug. If a build behaves strangely, ask the developer whether it is the right one.
<!-- src: 04 #366 -->

(executables)=
## Executables

### Linux

The official site lists these Linux files. Dates are from the official file index (checked October 2026).
<!-- src: 01 §2.1, §2.2 -->

| File | Date | Description |
|---|---|---|
| `p` | 2023-06-25 | Main x86-64 executable, probably statically linked. |
| `p4` | 2023-06-25 | Build "for FMA/AVX2" processors. |
| `p_d` | 2021-11-12 | Dynamically linked build. |
| `p4_d` | 2025-02-28 | Dynamically linked FMA/AVX2 build. |
| `p_l` | 2025-04-14 | Build for a particular cluster, started through a cluster-side Intel MPI wrapper. |
| `p_mvs1p1`, `p_mvs10p`, `p_mvs10q` | 2019–2023 | Builds for particular clusters. |
| `p_arm`, `mpiexec_arm` | 2015-09-23 | ARM build and its MPI launcher. |
| `mpiexec` | 2012-09-09 | MPI launcher shipped with `p`. |
| `xm` | 2025-04-24 | A molecule viewer. It takes a Priroda input file as its argument (`xm C60.qm.in`). |

That `p` is statically linked is inferred from the description of `p_d` as "dynamically linked". The site does not say
which cluster each `p_mvs*` and `p_l` build is for.
<!-- src: 01 §2.1 (inferred) -->

Older distributions used other names: `p6`, `p6_32` and `p6_64` for version 6, `p9`, and `p1` for version 11 at one
site. Scripts and forum posts written for those versions use these names. This manual writes `p` throughout.
<!-- src: 03 §1; 02 §5.1; 04 #127 -->

Some users run the Linux build under WSL on Windows. <!-- src: 04 #508 -->

### Windows

The Windows build is a Cygwin build for x86-64. It is in the `exe64/` directory of the official site:
<!-- src: 01 §2.2 -->

| File | Date | Description |
|---|---|---|
| `p1.exe` | 2021-10-01 | Serial executable. |
| `p1_190306.exe` | 2019-03-12 | Older serial build. |
| `p_190306.exe` | 2019-03-12 | Older parallel (MPI) build. |
| `xm.exe` | 2019-03-08 | Viewer. |
| `cygwin1.dll` | 2021-10-01 | Cygwin runtime library. |

For serial runs you need only `p1.exe` and `cygwin1.dll` in the same directory. A full Cygwin installation is not
required, and no administrator rights are needed. For parallel runs see {ref}`running-windows-parallel`.
<!-- src: 04 #362, #370; 08 w01 -->

The Windows builds are older than the Linux one: `p1.exe` prints `Priroda 20 (2021.03.18)` and `p_190306.exe` prints
`Priroda 19 (2019.03.06)`. For water the serial `p1.exe` gave the same energy as Linux version 25 to all printed
digits, and the same optimized geometry and frequencies. Features added after version 20 are missing from the
Windows builds.
<!-- src: 08 w01, w11, w12, w13b -->

In 2017 users referred to the parallel Windows build as `exe64/p.exe`. The current index has no `p.exe`; the newest
parallel build there is `p_190306.exe`.
<!-- src: 04 #370; 01 §2.2 -->

Old 32-bit Windows builds could not allocate more than about 1 GB of memory; `malloc(...) failed` appeared above that.
The 64-bit `p1.exe` ran with `mem=3000` without trouble.
<!-- src: 04 #94-#105, #210, #211, #370; 08 w07 -->

## Running a calculation

### Serial runs

Give the input file first and the output file second:

```bash
p input.in output.out
```

On Windows:

```bat
p1.exe input.in output.out
```

<!-- src: 01 §2.1; 04 #64, #127, #504 -->

On Linux the current directory is usually not in `PATH`, so start the program as `./p` or with its full path. If the
program cannot find the input or the basis file, give full paths everywhere: for the executable, the input, the
output, and the basis file inside the input.
<!-- src: 04 #153, #154 -->

Run in a directory you own and can write to. Keep file and directory names to Latin letters, digits and simple
punctuation, with no spaces or Cyrillic. This also applies to the computer name on Windows. File names are
case-sensitive on Linux, although keywords are not.
<!-- src: 04 #171; 03 §2 (amg, Nov 2011); 06 §2 -->

The Windows `p1.exe` (version 20) did run in a folder with a space in its name, both from inside it and from outside
with the paths in double quotes. Full Windows paths such as `C:\Work\mol.in` work for the input and output files.
<!-- src: 08 w09, w10 -->

One user of an older version saw the complaint `0: output file 'tasK.out'?` when the output file name contained a
capital letter. Version 25 writes to an output file with capital letters in its name without complaint.
<!-- src: 04 #161; 08 t19 -->

If no output file is given (`p input.in`), the output goes to standard output. <!-- src: 03 §2; 02 §5.1; 08 t20, w08 -->

### Parallel runs on Linux

Priroda is parallelized with MPI. Start a parallel run through an MPI launcher. The official site shows the
`mpiexec` that it ships next to `p`:

```bash
./mpiexec -np 4 ./p input.in output.out
```

<!-- src: 01 §2.1; 08 t21b (works in v25) -->

The output then starts with `parallel on 4 processors` and one `node N:` line per process. A two-process test gave
exactly the serial energy.
<!-- src: 08 t21b -->

Older versions also accepted `p -np 4 input.in output.out`, which users ran with versions 6 and 10. **Version 25 does
not**: it takes `-np` as the input file name, prints `input file '-np'?.` and stops. One site ran version 14 with
the bundled `mpiexec` (`mpiexec -np N p input.in`, output to standard output).
<!-- src: 04 #66, #150-#154; 02 §5.1; 08 t21a -->

Check the start of the output. A parallel run prints the number of processes and one line per process:

```text
 parallel on  4 processors
 node  0: 'linux-ldmm'
 node  1: 'linux-ldmm'
 ...
```

<!-- src: 04 #152; 01 §2.6 -->

The official site gives one example for a cluster build, `p_l` under Slurm:

```bash
sbatch -p test -n 16 -t 6 impi ~/bin/p_l file.{in,out}
```

Here `impi` is presumably that cluster's Intel MPI wrapper script; it is not part of Priroda.
<!-- src: 01 §2.1 (impi inferred) -->

Parallel runs on Windows, scaling and batch-job scripts are covered in {doc}`parallel`.

## Memory, disk and scratch: `$system`

The {ref}`$system <group.system>` group sets the resources. Every limit applies **per MPI process**.
`disk=10` on four processes can use up to 40 GB.
<!-- src: input.txt; 03 §3; 04 #196 -->

```priroda
$system memory=2048 disk=-2048 path=/scratch/user $end
```

{ref}`memory <system.memory>`
: Memory in MB. Two values set rank 0 and the other ranks separately: `mem=2048,256` gives the master process
  2048 MB and every other process 256 MB. The version 5 documentation says that in a parallel run most of the memory and
  all of the disk storage are used by rank 0. That is why a small second value works: the other ranks need less.
  <!-- src: 01 §4.1; 06 §3 -->

{ref}`disk <system.disk>`
: A positive value is scratch disk in **GB**. The program opens one scratch file per gigabyte. A negative value is
  scratch kept in memory, in **MB** (a RAM disk): `disk=-2048` holds 2048 MB of scratch in RAM. A second value
  applies to the other ranks, as for `memory`; the official example inputs typically give them `-1`.
  <!-- src: input.txt; Dft.rtf; 04 #196, #468; 01 §4.1 -->

{ref}`path <system.path>`
: The scratch directory. A colon-separated list gives one directory per process, which pays off only when the
  directories are on different physical drives. For several processes and one fast disk, a single directory is
  enough.
  <!-- src: input.txt; 04 #66 -->

(running-ram-disk)=
### Keeping scratch in memory

With a negative `disk`, `memory` plus |`disk`| is taken by every process, so the sum over all processes must fit
into the node's physical RAM, or the run stops at once with `malloc(...) failed`. With `mem=a,b` and `disk=a,b`,
rank 0 takes the first values and every other rank the second. One user's setting for a 24 GB node is
`memory=9000 disk=-14000`; that fills the node with **one** process. On several processes, give the other ranks
small second values or lower the limits.
<!-- src: 04 #462, #463, #471; 01 §4.1 -->

Keeping the scratch in RAM is faster than a local disk; one user calls it "a bit faster". In an older cluster
benchmark the gain was larger: a version 8 RI-MP2 job on 8 cores (4 nodes) took 12.4 minutes with scratch in RAM,
against 72 minutes on 2 cores with scratch on disk and 86 minutes on 8 cores with direct SCF and scratch on disk.
<!-- src: 04 #462; 03 §3 (v8 benchmark, mpich/Myrinet, 4 nodes x 2 cores) -->

(running-scratch)=
### Where scratch files go

The scratch directory is taken from `path=`, then from the `TMPDIR` environment variable. The files are named
`tmp<number>.<suffix>`, for example `/tmp/tmp2960.0` or `/tmp/tmp9633.11`. In version 25 each process of a parallel
run wrote its own file with a different number and the same suffix (`tmp5345.0000`, `tmp5346.0000`). Priroda deletes
them at the end of a normal run, and in version 25 also when the job is stopped with signal 15 (SIGTERM). After a
crash, delete the leftovers yourself.
<!-- src: input.txt; 04 #20, #460, #465; 02 §5.2; 08 Slurm tests (s02, s04); deletion after a normal run: 06 §4 (Tutorial v6) -->

When neither `path=` nor `TMPDIR` is set, version 25 puts scratch files in `/tmp` (echo `Disk:   1g '/tmp'`), as
version 6 did. `input.txt` says the current working directory instead, and a 2020 user report gives the directory of
the input file; neither matches version 25. `/tmp` is often small or shared, so set `path=` or `TMPDIR` for real jobs.
<!-- src: input.txt; 04 #465, #20; 08 t64 (TMPDIR unset: /tmp; TMPDIR set: used) -->

On Windows there is no `/tmp`. Without `path=` or `TMPDIR`, the run stops after printing
`0: opening file /tmp/tmp978.0000` (the number varies), and the output ends with `process 0 got signal 6`. This
still happens with `p1.exe` (version 20). Any of these avoids it:

- `$system path=. $end` (the current directory);
- `TMPDIR` set to a Windows path: in `cmd.exe`, `set TMPDIR=%TEMP%` or `set "TMPDIR=%TEMP%"`. Do not write
  `set TMPDIR="%TEMP%"`: `cmd.exe` keeps the quotes in the value, Priroda takes the result as a relative path, and
  the run stops in the same way;
- a RAM disk (negative `disk`), which needs no scratch directory. An input with no `$system` group gets a 512 MB RAM
  disk and runs.
<!-- src: 04 #20, #21; 03 §2; 08 w02a-d, w03, w04 -->

(running-disk-speed)=
### Disk speed

:::{warning}
Never put scratch files on NFS or another network file system. On most clusters the home directories are on NFS;
use the node-local scratch disk instead.
:::
<!-- src: input.txt; 06 §3, §7 -->

Priroda is sensitive to disk speed. The unofficial keyword list `input.txt` warns that for all methods except GGA DFT, performance
"will be degraded terribly" if more than one process reads and writes large files on the same physical drive. In
order of preference:
<!-- src: input.txt; 04 #181, #293 -->

1. keep the scratch in RAM (negative `disk`) if it fits;
2. give each process its own physical drive with `path=a:b:c:d`;
3. put all processes on one fast local disk (SSD), accepting some loss.

If the disk is the bottleneck for RI-MP2 or RI-DFT, {ref}`$integral direct=1 <integral.direct>` recomputes the
integrals instead of storing them. One user found it uses about a third of the memory but runs about ten times
longer in CPU time. In a disk-bound RI-MP2 optimization another user got 20 steps overnight with it instead of 2.
<!-- src: 03 §5 (post #0); 04 #185, #192, #194 -->

Users also recommend more RAM over faster disks. Scratch on a separate SSD helps, but RAM matters more.
<!-- src: 04 #189, #194 -->

### When the limits are too small

Priroda does not fall back to a slower algorithm when memory or scratch runs out. The run stops with an error such as
`need … bytes.` (the `memory` limit is too small), `malloc(536870912) failed` (the machine cannot supply the memory)
or, for scratch, `0: out of disk space (grid_W), 8213824` (version 25; older versions printed the number with
`KB`). Raise the limit in `$system`, move to a node with more resources, or choose a cheaper
method (RI-MP2 instead of conventional MP2).
<!-- src: 04 #58, #199; 03 §4; 08 t61, t62 -->

If you omit `$system`, version 6 printed `Memory: 128 (128) MB` and `Disk: 1 GB '/tmp'`. Version 25 prints
`Memory: 256m + 512m (256m + 512m)` and no `Disk:` line. Read by the echo format, that is 256 MB of memory and a
512 MB RAM disk per process.
That is enough for small molecules only, so always give `$system` for anything larger than a test.
<!-- src: 03 §2; 04 §4 (#20); 08 t02 (RAM-disk reading inferred from the echo format) -->

If a run fails for lack of memory or disk, see {ref}`troubleshooting.memory`.

(running-input-files)=
## Input file requirements

The input is a plain text file. Write it in a plain-text editor, not a word processor.

- **Plain ASCII.** Keywords, values and file names should contain ASCII characters only. Do not save the file as
  Unicode.
  <!-- src: 04 #104, #113, #117 -->
- **Unix line endings (LF).** This holds on Windows too. Saving from Word as "plain text" still leaves Windows (CRLF)
  line endings, and some editors need to be told explicitly to write Unix line endings.
  <!-- src: 03 §2; 04 #113, #117 -->
- **Straight quotes.** Write `basis="3z.bas"` with the ASCII double quote. Typographic quotes, as in `basis=»3z.bas»`,
  break the basis-file name.
  <!-- src: 04 #64 -->

Users of versions 6–10 reported that an input with CRLF line endings fails in `$molecule`, because the carriage
return becomes part of the keyword. The output stops after a line like this, where the keyword `z-matrix` or `cartesian` is shown garbled by the carriage
return:

```text
 molecule input: ''
' ?matrix
```

Variants seen are `?rtesian` for `cartesian`, `'z-matrix' ?`, and `'cartesian` followed by `' ?` on the next line. A
less obvious case: an input edited in Word ran `task=scan` as a plain optimization.
<!-- src: 04 #63-#65, #110, #113, #172; 03 §2, §15 (versions 6-10, 2010-2012) -->

Version 25 behaves the same way: a water input saved with Windows line endings stopped after `molecule input: ''`
with the line `'cartesian' ?`, exit status 1. The Windows build `p1.exe` (version 20) stops in the same place, so
the input needs Unix line endings on Windows too. <!-- src: 08 t81a, w06 -->

To check and fix the line endings on Linux:

```bash
file mol.in        # reports "with CRLF line terminators" if the file has Windows endings
dos2unix mol.in
```

Running `dos2unix` on a file that already has Unix line endings does no harm. On Windows, Notepad++ and the FAR
Manager editor (Shift+F2, then UNIX (LF)) can convert line endings.
<!-- src: 04 #64, #174; 03 §2 -->

For the full list of input-reading failures and their symptoms, see {ref}`troubleshooting.input`.

## Basis-set files

The basis sets, their auxiliary (fitting) sets and the ECPs are read from a separate file named by
{ref}`$control basis <control.basis>`. The set itself is chosen with {ref}`set= <molecule.set>` in `$molecule`; without
it, the default set of the file is used. Without `basis=`, the basis data are read from the input file itself.
<!-- src: input.txt; 03 §5 -->

Give the basis file as a **full path**:

```priroda
$control task=optimize basis=/home/user/priroda/basis/basis.in $end
```

In version 25, `basis=basis.in` works when the file is in the directory you run from, which in the test was also
the directory of the input. One user's parallel run stopped after
the node list with `application called MPI_Abort(MPI_COMM_WORLD, 1) - process 0` and worked once the basis file was
given with its full path.
<!-- src: 04 #152-#154; 01 §2.4 (Windows: qm.in found in the current directory); 08 t03 -->

- The name can be put in double quotes: `basis="3z.bas"` works. Two single quotes do not work; `basis=''3z.bas''`
  fails with `error opening file ''3z.bas''`.
  <!-- src: 03 §2; 02 §3 -->
- Windows paths work: `basis=D:\NMR\Nature\basis\6-31+G(d)`. In a test, `basis=C:\Priroda\basis.in`,
  `basis=C:/Priroda/basis.in` and `basis=basis.in` (the file in the directory the run started from) all worked.
  <!-- src: 04 #319; 08 w05 -->
- The relativistic file `basis4.in` needs `four=1` in `$control`. Without it the basis input fails: in version 25
  the output ends right after `Basis set input: '…/basis4.in'` with the single line `1?`.
  <!-- src: 04 #206-#208, #336; 08 t49 -->

Which basis files exist and which sets they contain is described with {ref}`$control basis <control.basis>`.
