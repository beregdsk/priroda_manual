# Installing and running

Priroda has no installer. You copy an executable, the basis-set files you need and, for parallel runs, the MPI
launcher into a directory, write an input file, and start the program with the input and output file names as
arguments.

## Executables

### Linux

The official site lists these Linux files. Sizes and dates are those of the 2025 file index.
<!-- src: 01 §2.1, §2.2 -->

| File | Date | Description |
|---|---|---|
| `p` | 2023-06-25 | Main x86-64 executable, statically linked. |
| `p4` | 2023-06-25 | Build "for FMA/AVX2" processors. |
| `p_d` | 2021-11-12 | Dynamically linked build. |
| `p4_d` | 2025-02-28 | Dynamically linked FMA/AVX2 build. |
| `p_l` | 2025-04-14 | Build for a particular cluster, started through the site's Intel MPI wrapper. |
| `p_mvs1p1`, `p_mvs10p`, `p_mvs10q` | 2019–2023 | Builds for particular clusters. |
| `p_arm`, `mpiexec_arm` | 2015-09-23 | ARM build and its MPI launcher. |
| `mpiexec` | 2012-09-09 | MPI launcher shipped with `p`. |
| `xm` | 2025-04-24 | The developer's molecule viewer. It takes a Priroda input file as its argument (`xm C60.qm.in`). |

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
<!-- src: 04 #362, #370 -->

:::{note}
In 2017 users referred to the parallel Windows build as `exe64/p.exe`. The current index has no `p.exe`; the newest
parallel build there is `p_190306.exe`.
:::
<!-- src: 04 #370; 01 §2.2 -->

Old 32-bit Windows builds could not allocate more than about 1 GB of memory; `malloc(...) failed` appeared above that.
Users report that the 64-bit build has no such limit.
<!-- src: 04 #94-#105, #210, #211, #370 -->

## Running a calculation

### Serial runs

Give the input file first and the output file second:

```text
p input.in output.out
```

On Windows:

```text
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

One user of an older version saw the complaint `0: output file 'tasK.out'?` when the output file name contained a
capital letter. Version 25 writes to an output file with capital letters in its name without complaint.
<!-- src: 04 #161; 08 t19 -->

If no output file is given (`p input.in`), the output goes to standard output. <!-- src: 03 §2; 02 §5.1; 08 t20 -->

### Parallel runs on Linux

Priroda is parallelized with MPI. Start a parallel run through an MPI launcher. The official site shows the
`mpiexec` that it ships next to `p`:

```text
./mpiexec -np 4 ./p input.in output.out
```

<!-- src: 01 §2.1; 08 t21b (works in v25) -->

The output then starts with `parallel on 4 processors` and one `node N:` line per process. A two-process test gave
exactly the serial energy.
<!-- src: 08 t21b -->

Older versions also accepted `p -np 4 input.in output.out`, which users ran with versions 6 and 10. **Version 25 does
not**: it takes `-np` as the input file name, prints `input file '-np'?.` and stops. One site ran version 14 as
`mpiexec -np 4 p input.in`, with the system's MPI launcher.
<!-- src: 04 #66, #150-#154; 02 §5.1; 08 t21a -->

Check the start of the output. A parallel run prints the number of processes and one line per process:

```text
 parallel on  4 processors
 node  0: 'linux-ldmm'
 node  1: 'linux-ldmm'
 ...
```

<!-- src: 04 #152; 01 §2.6 -->

The cluster builds are started through the cluster's own MPI. The official example for `p_l` under SLURM is:

```text
sbatch -p test -n 16 -t 6 impi ~/bin/p_l file.{in,out}
```

Here `impi` is that cluster's wrapper script for Intel MPI, not part of Priroda.
<!-- src: 01 §2.1 (impi inferred) -->

(running-windows-parallel)=
### Parallel runs on Windows

The official site shows this command for a two-process run:

```text
mpirun.exe -np 2 p.exe C60.qm.in C60.qm.w.2.out
```

The MPI runtime is not on the site. Users assembled it from Cygwin as follows:
<!-- src: 01 §2.1; 04 #365, #370, #397, #472 -->

1. Download the 64-bit Cygwin installer (`setup-x86_64.exe` from <https://cygwin.com>). Install the default packages
   plus the `openmpi` package.
2. Copy these files from the Cygwin installation into the directory with the Priroda executable:
   `cygwin1.dll`, `cyggcc_s-seh-1.dll`, `cygmpi-12.dll`, `cygopen-pal-13.dll`, `cygopen-rte-12.dll`, `orterun.exe`.
   Newer OpenMPI packages have `cygopen-pal-40.dll` and `cygopen-rte-40.dll` instead of the `-13`/`-12` files; take
   those. Take `cygwin1.dll` from the same installation, because the other DLLs work only with matching versions.
   After this, Cygwin itself is no longer needed.
3. Create a directory `dev` one level above the directory you start Priroda from, with subdirectories `shm` and
   `mqueue`. For Priroda in `C:\Priroda`, that means `C:\dev\shm` and `C:\dev\mqueue`. Without a Cygwin installation,
   the Cygwin libraries take the parent of the start directory as the root `/`.
4. If the program is in a system directory such as `C:\Program Files`, run it as administrator.
5. Set `TMPDIR` and start the run from `cmd.exe`:

   ```text
   cd /d "C:\Priroda"
   set TMPDIR="%TEMP%"
   orterun.exe -np 2 p.exe "C:\Work\file.in" "C:\Work\file.out"
   ```

<!-- src: 04 #370, #397, #472 -->

Problems reported with this setup:

- The recipe needs a Priroda build that supports parallel runs. Version 6 (`p6.exe`) failed with an OpenMPI
  `agent-not-found` error; users moved to version 17. <!-- src: 04 #398, #401 -->
- On a computer connected by Wi-Fi that also has a wired network adapter, OpenMPI stops with
  `tcp_peer_send_blocking: send() to socket 12 failed: Transport endpoint is not connected (128)`. Disable the wired
  adapter. <!-- src: 04 #397 -->
- With the Ethernet cable unplugged, one user's run used only two of the cores. <!-- src: 04 #374 -->
- `Warning: '/dev/shm' does not exists or is not a directory.` means the Cygwin environment is missing. Create the
  `dev` directories (step 3), or start from a Cygwin shell. <!-- src: 04 #360, #370 -->

:::{warning}
A user reported in 2021 that this recipe no longer worked on Windows 10 with a current Cygwin, and no fix was posted.
Expect to adapt it to the Cygwin and OpenMPI versions you have.
:::
<!-- src: 04 #472 -->

## Memory, disk and scratch: `$system`

The {ref}`$system <group.system>` group sets the resources. Every limit applies **per MPI process**.
`disk=10` on four processes can use up to 40 GB.
<!-- src: input.txt; 03 §3; 04 #196 -->

```text
$system memory=2048 disk=-2048 path=/scratch/user $end
```

{ref}`memory <system.memory>`
: Memory in MB. Two values set rank 0 and the other ranks separately: `mem=2048,256` gives the master process
  2048 MB and every other process 256 MB. In a parallel run, most of the memory and all of the disk storage are
  used by rank 0, so give the other ranks less.
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

### Keeping scratch in memory

With a negative `disk`, `memory` plus |`disk`| must fit into the physical RAM for each process, or the run stops at
once with `malloc(...) failed`. One user's setting for a 24 GB node is `memory=9000 disk=-14000`. Keeping the scratch
in RAM is faster than any disk. In one RI-MP2 benchmark on 8 cores it cut the time from 86 minutes (scratch on disk)
to 12.4 minutes.
<!-- src: 04 #462, #463, #471; 03 §3 (v8 benchmark) -->

### Where scratch files go

The scratch directory is taken from `path=`, then from the `TMPDIR` environment variable. The files are named
`tmp<number>.<rank>`, for example `/tmp/tmp2960.0`. Priroda deletes them at the end of a normal run; after a crash,
delete the leftovers yourself.
<!-- src: input.txt; 04 #20, #465; 06 §4 (Tutorial v6); 02 §5.2 -->

:::{note}
The fallback when neither `path=` nor `TMPDIR` is set is reported differently. `input.txt` says the current working
directory. A 2020 user report says the directory of the input file. Version 6 printed `Disk: 1 GB '/tmp'` when
`$system` was omitted, and version 25 printed `Disk:   1g '/tmp'` for `disk=1` without `path=` (whether `TMPDIR` was
set in that test is not known). Set `path=` or `TMPDIR` explicitly.
:::
<!-- src: input.txt; 04 #465; 04 #20; 08 t01 --> <!-- verify -->

On Windows there is no `/tmp`. Without `path=` or `TMPDIR`, older versions stopped after printing
`0: opening file /tmp/tmp2960.0`. Use `$system path=. $end` (the current directory) or set `TMPDIR`.
<!-- src: 04 #20, #21; 03 §2 -->

### Disk speed

:::{warning}
Never put scratch files on NFS or another network file system. On most clusters the home directories are on NFS;
use the node-local scratch disk instead.
:::
<!-- src: input.txt; 06 §3, §7 -->

Priroda is sensitive to disk speed. Priroda's own documentation (`input.txt`) warns that for all methods except GGA DFT, performance
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
`malloc(536870912) failed` (memory) or `0: out of disk space (VNNNN), 184441541KB` (scratch). The number in the disk
message is the amount needed. Raise the limit in `$system`, move to a node with more resources, or choose a cheaper
method (RI-MP2 instead of conventional MP2).
<!-- src: 04 #58, #199; 03 §4 -->

If you omit `$system`, version 6 printed `Memory: 128 (128) MB` and `Disk: 1 GB '/tmp'`. Version 25 prints
`Memory: 256m + 512m (256m + 512m)` and no `Disk:` line: 256 MB of memory and a 512 MB RAM disk per process.
That is enough for small molecules only, so always give `$system` for anything larger than a test.
<!-- src: 03 §2; 04 §4 (#20); 08 t02 (RAM-disk reading inferred from the echo format) -->

(running-parallel-scaling)=
If a run fails for lack of memory or disk, see {ref}`troubleshooting.memory`.

## Parallel performance

Users consistently report the following:
<!-- src: 04 §0 -->

- **DFT scales well within one node, up to about 6–8 cores.** Beyond 8 cores the gain is at most about 10%, even for
  large systems. One 38-step optimization took 101, 63 and 37 s on single nodes with 8, 12 and 24 cores. A small
  PBE/L1 optimization with version 10 took 81.5, 42.5, 29.8 and 29.3 s on 1–4 cores.
  <!-- src: 04 #343, #344, #154 -->
- **Running across nodes gives no gain for DFT.** Use one node per job.
  <!-- src: 04 #344, #462; 03 §3 -->
- **Memory per process does not drop** when you add processes, and in a parallel Hessian nearly all of the disk use is
  on rank 0.
  <!-- src: 04 #181, #185 -->
- **RI-MP2 parallelizes better than DFT**, at least in memory. The v5 documentation limits useful parallelism to
  Nproc ≤ min(N_atoms, N_occ) and recommends a number of processes that divides the number of occupied orbitals
  nearly evenly. For N_occ = 14 it rates 2, 7 or 14 processes as best, 3 or 5 as acceptable, 6 as poor and 13 as very
  bad.
  <!-- src: 04 #343; 06 §3 -->
- **Small RI jobs on many processes can hang.** RI-MP2 and RI-DFT hang with no message when a process receives no
  work. The output then shows a line `0 blocks ... on node N` after `integral estimates`. Run small RI jobs on one or a
  few cores.
  <!-- src: 05 §3.1 -->
- **Several independent jobs often beat one parallel job.** On a 4-core machine, four single-core jobs ran about 30%
  faster in total than the same jobs run one after another on 4 cores each.
  <!-- src: 03 §3 (amg, 2009) -->

Results can differ in the last digits between runs on different numbers of processes. An unstable TS search was once
seen to follow different paths for different `-np`.
<!-- src: 03 §3 (amg, Nov 2008) -->

:::{note}
Older versions scaled worse. In version 6 a parallel Hessian could use at most 2 cores and could hang on 4, and a
version 7 MP2 run hung on more than about 24 cores. Use version 17 or later for parallel work.
:::
<!-- src: 03 §3; 04 #66, #401 -->

Hangs, crashes and poor speed-up in parallel runs are covered in {ref}`troubleshooting.parallel`.

## Batch systems

Priroda needs nothing special from a batch system. The job script has to:

1. request **one node** and the number of cores you will use (see {ref}`parallel performance above <running-parallel-scaling>`);
2. point the scratch to the node's local disk or to RAM, by exporting `TMPDIR` or by `path=` in `$system`;
3. make the memory request cover `memory` + |negative `disk`| for every process;
4. start Priroda with the input and output file names.

<!-- src: 06 §7; 04 #462 -->

A SLURM script along these lines should work. Directory names and module setup are site-specific.

```text
#!/bin/bash
#SBATCH --job-name=mol
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --time=24:00:00

PRIRODA=$HOME/priroda/p                      # full path to the executable
cd "$SLURM_SUBMIT_DIR"
export TMPDIR=/local/scratch/$SLURM_JOB_ID   # node-local disk; site-specific
mkdir -p "$TMPDIR"

$HOME/priroda/mpiexec -np "$SLURM_NTASKS" "$PRIRODA" mol.in mol.out   # the mpiexec from the official site

rm -rf "$TMPDIR"
```

<!-- verify -->

Under PBS/Torque the same steps read the number of cores from `$PBS_NODEFILE`. PBS often provides a per-job local
scratch directory and deletes it after the job.
<!-- src: 06 §7 (PBS_Tutorial) -->

```text
#!/bin/bash
#PBS -N mol
#PBS -l nodes=1:ppn=8,walltime=24:00:00

cd "$PBS_O_WORKDIR"
NP=$(wc -l < "$PBS_NODEFILE")
export TMPDIR=/local/scratch/$PBS_JOBID      # site-specific
mkdir -p "$TMPDIR"

$HOME/priroda/mpiexec -np "$NP" $HOME/priroda/p mol.in mol.out

rm -rf "$TMPDIR"
```

<!-- verify -->

If `/tmp` on the node is small or has a quota, a large job dies writing a scratch file, for example
`0: write file /tmp/tmp9633.11 (leAX): ...`. Point the scratch at the cluster's scratch file system or at RAM.
<!-- src: 04 #460, #462 -->

:::{note}
**Historical: the KNC wrappers.** The Kazan Scientific Centre clusters (2006–2012) provided the wrappers
`pbspriroda5`, `pbspriroda5-mpi` and `pbspriroda6`, called as `pbspriroda6 file_name -time hh:mm:ss -queue queue
-mem MB -disk size -procs 1:ppn=N`. The wrappers wrote the `$system` group themselves from `-mem` and `-disk`, so
inputs submitted through them had to omit `$system`. Forum posts and old FAQs that mention these commands refer to
that site only.
:::
<!-- src: 06 §7 -->

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

An input with CRLF line endings fails in `$molecule`, because the carriage return becomes part of the keyword. The
output stops after a line like this, where the keyword `z-matrix` or `cartesian` is shown garbled by the carriage
return:

```text
 molecule input: ''
' ?matrix
```

Variants seen are `?rtesian` for `cartesian`, `'z-matrix' ?`, and `'cartesian` followed by `' ?` on the next line. A
less obvious case: an input edited in Word ran `task=scan` as a plain optimization.
<!-- src: 04 #63-#65, #110, #113, #172; 03 §2, §15 -->

To check and fix the line endings on Linux:

```text
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

```text
$control task=optimize basis=/home/user/priroda/basis/basis.in $end
```

A relative name is looked up relative to the directory the program runs in; in version 25, `basis=basis.in` works
when the file is in that directory. One user's parallel run stopped after
the node list with `application called MPI_Abort(MPI_COMM_WORLD, 1) - process 0` and worked once the basis file was
given with its full path.
<!-- src: 04 #152-#154; 01 §2.4 (Windows: qm.in found in the current directory); 08 t03 -->

- Put the name in double quotes if the path contains special characters: `basis="/data/basis sets/basis.in"`. Two
  single quotes do not work; `basis=''3z.bas''` fails with `error opening file ''3z.bas''`.
  <!-- src: 03 §2; 02 §3 -->
- Windows paths work: `basis=D:\NMR\Nature\basis\6-31+G(d)`.
  <!-- src: 04 #319 -->
- The relativistic file `basis4.in` needs `four=1` in `$control`. Without it the basis input fails.
  <!-- src: 04 #206-#208, #336 -->

Which basis files exist and which sets they contain is described with {ref}`$control basis <control.basis>`.
