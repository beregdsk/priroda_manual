<!-- Generated from keywords/system.yaml by docs/_ext/priroda_keywords.py. Do not edit. -->


(group.system)=
# `$system`

```{index} single: $system
```

Memory, disk and scratch-directory limits.

All limits apply **per MPI process**. For example, `disk=10` on four processes can use 40 GB. For GGA DFT, the
v5 documentation and a v8 benchmark report that most of the memory and all of the disk storage are used by the
master process (rank 0). RI-MP2 and the other correlated methods write large scratch files on every process.
In version 25, a two-process DFT run left one scratch file per process.

(system.memory)=
## `memory`

```{index} single: memory ($system)
```

**Type:** list\
**Default:** `256`\
**Units:** MB\
**Status:** current · verified on 25 (2025.02.28)\
**Sources:** input.txt; 01 §4.1 (two values); 06 §3 (estimate); 03 §4, 04 #196 (per process); 08 t02, t58a, w04 (same echo in the Windows version 20)

Default: echoed by version 25 when `$system` is omitted.

Memory limit in megabytes. A second value sets the limit for the other MPI ranks: `mem=2048,256` gives rank 0
2048 MB and every other rank 256 MB. A single value applies to all ranks. The output echoes the result as
`Memory: <mem>m + <|disk|>m (<mem2>m + <|disk2|>m)`.

```{note}
For DFT, the v5 documentation estimates the memory as about 8·N²·3 bytes for energy and gradient, and twice that
for an analytic Hessian, where N is the basis dimension. `Dft.rtf` gives an old default of 16 MB.
Without a `$system` group, version 25 echoes `Memory: 256m + 512m (256m + 512m)`, the same form that
`mem=512 disk=-512` gives. This is read as 256 MB of memory plus a 512 MB RAM disk per process
*(inferred from the echo format)*.
```

(system.disk)=
## `disk`

```{index} single: disk ($system)
```

**Type:** list\
**Default:** `-512`\
**Status:** current · verified on 25 (2025.02.28)\
**Sources:** input.txt; Dft.rtf (one file per GB); 01 §4.1; 04 §0, #468; 03 §3, §17; 08 t02, t58a, t62, t64; 06 §3, 08 Slurm s02 (scratch per process)

Default: a 512 MB RAM disk *(inferred from the version 25 echo `Memory: 256m + 512m` when `$system` is omitted)*.

Positive values set the disk space in gigabytes; one scratch file is opened per gigabyte, which sidesteps
per-file size limits. Negative values set the amount of memory, in megabytes, used to emulate disk
(a RAM disk). A second value applies to the other MPI ranks, as for `memory`; the official example inputs typically give
them `-1`.

```{note}
With a RAM disk, `memory` plus |`disk`| (times the number of processes) must fit in physical RAM, or the run
fails with `malloc(...) failed`. Example for a 24 GB node running a single process: `memory=9000 disk=-14000`.
On one cluster, an RI-MP2 job on 8 cores with scratch in RAM ran 6× faster than on 2 cores with scratch on
disk (a v8 benchmark; core count and scratch location both changed).
In version 25, `disk=-512` was echoed as `Memory: 512m + 512m` with no `Disk:` line, `disk=1` as
`Disk:   1g '/tmp'`, and conventional MP2 with `disk=-1` stopped with `0: out of disk space (grid_W)`.
```

**Example:**

```text
$system mem=2048,256 disk=-256,-1 $end
```

(system.path)=
## `path`

```{index} single: path ($system)
```

**Type:** string\
**Default:** *none stated*\
**Status:** current · verified on 25 (2025.02.28)\
**Sources:** input.txt; 03 §2; 04 #465; 08 t01, t64, w02a-d, w03

Default: the `TMPDIR` environment variable, otherwise `/tmp` (version 25). `input.txt` says the current working directory.

Directory for temporary disk files. For parallel runs you can give a colon-separated list with one path per
process: `path=/tmpa:/tmpb:/tmpc:/tmpd` makes process 1 write to `/tmpa`, process 2 to `/tmpb`, and so on.
Those directories should be on different physical drives. The value may be double-quoted.

```{note}
For all methods except GGA DFT, performance degrades "terribly" if more than one process reads and writes
large files on the same physical drive. Never put temporary files on NFS. Version 25, run without `path=`,
used `TMPDIR` when it was set and `/tmp` when it was not (echo `Disk:   1g '/tmp'`). The Windows `p1.exe`
(version 20) does the same, and as Windows has no `/tmp` the run then stops at `0: opening file /tmp/…`. Use
`path=.`, set `TMPDIR` to a Windows path without quotes (`set TMPDIR=%TEMP%` in `cmd.exe`), or use a RAM disk.
```

**Example:**

```text
$system path=/tmpa:/tmpb:/tmpc:/tmpd $end
```
