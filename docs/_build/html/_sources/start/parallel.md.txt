(start.parallel)=
# Parallel and cluster runs

This chapter covers what goes beyond a run on one Linux machine: parallel runs on Windows, how well Priroda scales,
and job scripts for batch systems. Starting a parallel run on Linux is described in {doc}`running`, and the
resource limits that apply to every process in {ref}`running-ram-disk` and the sections around it.

(running-parallel-scaling)=
## Parallel performance

What is known about parallel performance:
<!-- src: 04 §0 -->

- **DFT speeds up within one node; reports differ on how far.** One user found in 2016 that beyond 6–8 cores the gain
  is at most about 10%, even for large systems such as (C60)9. Another measured a 38-step optimization of a small
  molecule at 101, 63 and 37 s on single nodes with 8, 12 and 24 cores. A small PBE/L1 optimization with version 10
  took 81.5, 42.5, 29.8 and 29.3 s on 1–4 cores. In a version 25 test, a numerical `ridft` Hessian of water took
  4.9 s on 2 processes instead of 7.2 s. An optimization plus analytic Hessian of a 22-atom copper complex
  (OLYP/L2, fine grid) took 32 min on 8 processes of one node; on one process it had not finished after an hour.
  <!-- src: 04 #343, #344, #154; 08 t63 (vs t32a), t72 (8 processes vs 1) -->
- **Parallel results equal serial ones in version 25 tests.** On 2 processes, a water energy and a numerical
  `ridft` Hessian gave exactly the serial numbers. In version 6, results were reported to differ in the last digits
  between runs on different numbers of processes, and an unstable TS search once followed different paths for
  different `-np`.
  <!-- src: 08 t21b, t63 (vs t32a); 03 §3 (amg, Nov 2008) -->
- **Running across nodes gives no gain for DFT.** Use one node per DFT job. RI-MP2 is the exception: the version 8
  benchmark under {ref}`running-ram-disk` ran 6 times faster on 4 nodes with scratch in RAM than on 2 cores of one node.
  <!-- src: 04 #344, #462; 03 §3 -->
- **Memory per process does not drop** when you add processes, and in a parallel Hessian nearly all of the disk use is
  on rank 0.
  <!-- src: 04 #181, #185 -->
- **RI-MP2 parallelizes better than DFT**, according to one user "at least in memory". The version 5 documentation limits useful
  parallelism to Nproc ≤ min(N_atoms, N_occ) and recommends a number of processes that divides the number of occupied orbitals
  nearly evenly. For N_occ = 14 it rates 2, 7 or 14 processes as best, 3 or 5 as acceptable, 6 as poor and 13 as very
  bad.
  <!-- src: 04 #343; 06 §3 -->
- **Small RI jobs on many processes can hang** (reported in 2015; not tested in version 25). RI-MP2 and RI-DFT hang
  with no message when a process receives no work. The output then shows a line `0 blocks ... on node N` after
  `integral estimates`. Run small RI jobs on one or a few cores.
  <!-- src: 05 §3.1 -->
- **Several independent jobs often beat one parallel job.** On a 4-core machine in 2009, for jobs not limited by
  disk, four single-core jobs ran about 30% faster in total than the same jobs run one after another on 4 cores each.
  <!-- src: 03 §3 (amg, May 2009) -->

Older versions scaled worse. In version 6 a parallel Hessian could use at most 2 cores and could hang on 4, and a
version 7 MP2 run crashed (signal 8) on more than about 24 cores. Use version 17 or later for parallel work.
<!-- src: 03 §3; 04 #66, #401 -->

Hangs, crashes and poor speed-up in parallel runs are covered in {ref}`troubleshooting.parallel`.

(running-batch)=
## Batch systems

Priroda needs nothing special from a batch system. The job script has to:

1. request **one node** and the number of cores you will use (for RI-MP2, see
   {ref}`parallel performance <running-parallel-scaling>`);
2. point the scratch to the node's local disk or to RAM, by exporting `TMPDIR` or by `path=` in `$system`;
3. make the memory request cover `memory` + |negative `disk`| for every process;
4. start Priroda with the input and output file names.

<!-- src: 06 §7; 04 #462 -->

This Slurm script was tested in version 25 on a single-node Slurm 23.11. Directory names and module setup are
site-specific.
<!-- src: 08 Slurm tests (s01-s05) -->

```bash
#!/bin/bash
#SBATCH --job-name=mol
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --time=24:00:00

PRIRODA=$HOME/priroda/p                      # full path to the executable
cd "$SLURM_SUBMIT_DIR"
export TMPDIR=/local/scratch/$SLURM_JOB_ID   # node-local disk; site-specific
mkdir -p "$TMPDIR"

env -i PATH="$PATH" HOME="$HOME" TMPDIR="$TMPDIR" \
  $HOME/priroda/mpiexec -np "$SLURM_NTASKS" "$PRIRODA" mol.in mol.out   # the mpiexec from the official site
status=$?

rm -rf "$TMPDIR"
exit $status
```

Two lines matter more than they look:

- **`env -i`.** The `mpiexec` from the official site refuses to start when the environment holds 193 or more
  variables. It prints `Environment is too large (max is 193)` and exits, and Priroda never runs. A Slurm job easily
  has that many, because Slurm adds its own `SLURM_*` variables; in the test, a job inherited 210 and the unmodified
  script failed this way. `env -i` starts `mpiexec` with only the variables listed.
- **`exit $status`.** Without it the job's exit status is that of `rm`, so Slurm reports a failed run as `COMPLETED`.
  This is what happened in the test above.
<!-- src: 08 Slurm tests (s01 as written; limit found by test: 192 variables run, 193 refused, exit 255) -->

When a job is cancelled (`scancel`) or reaches its time limit, Slurm sends signal 15 (SIGTERM). Priroda then writes
`process 0 got signal 15` and then `process 0 got signal 2` to the output, deletes its own scratch files, and stops;
Slurm's own log file says `CANCELLED` or `CANCELLED ... DUE TO TIME LIMIT`. The `rm` at the end of the script does
not run, so the empty scratch directory stays. To remove it as well, set the clean-up as a trap before starting
Priroda: replace the lines of the script from `env -i` through `exit $status` with these.

```bash
trap 'rm -rf "$TMPDIR"' EXIT
trap 'exit 143' TERM
env -i PATH="$PATH" HOME="$HOME" TMPDIR="$TMPDIR" \
  $HOME/priroda/mpiexec -np "$SLURM_NTASKS" "$PRIRODA" mol.in mol.out &
wait $!
```

<!-- src: 08 Slurm tests (s02-s04) -->

Two jobs of one process each ran side by side on the same node without trouble, each with its own scratch
directory. <!-- src: 08 Slurm tests (s05) -->

Under PBS/Torque the same steps read the number of cores from `$PBS_NODEFILE`. This script was not tested; it
uses `env -i` and `exit $status` for the same reasons as the Slurm one. Some PBS sites (e.g. KNC) provide a
per-job local scratch directory and delete it after the job.
<!-- src: 06 §7 (PBS_Tutorial) -->

```bash
#!/bin/bash
#PBS -N mol
#PBS -l nodes=1:ppn=8,walltime=24:00:00

cd "$PBS_O_WORKDIR"
NP=$(wc -l < "$PBS_NODEFILE")
export TMPDIR=/local/scratch/$PBS_JOBID      # site-specific
mkdir -p "$TMPDIR"

env -i PATH="$PATH" HOME="$HOME" TMPDIR="$TMPDIR" \
  $HOME/priroda/mpiexec -np "$NP" $HOME/priroda/p mol.in mol.out
status=$?

rm -rf "$TMPDIR"
exit $status
```

<!-- verify: PBS not testable on one PC; same steps as the tested Slurm script -->

If `/tmp` on the node is small or has a quota, a large job dies writing a scratch file, for example
`0: write file /tmp/tmp9633.11 (leAX): ...`. Point the scratch at the cluster's scratch file system or at RAM.
<!-- src: 04 #460, #462 -->

**Historical: the KNC wrappers.** The Kazan Scientific Centre clusters (2006–2012) provided the wrappers
`pbspriroda5`, `pbspriroda5-mpi` and `pbspriroda6`, called as `pbspriroda6 file_name -time hh:mm:ss -queue queue
-mem MB -disk size -procs 1:ppn=N`. The wrappers wrote the `$system` group themselves from `-mem` and `-disk`, so
inputs submitted through them had to omit `$system`. Forum posts and old FAQs that mention these commands refer to
that site only.
<!-- src: 06 §7 -->

A run killed with signal 15 alone (for example by `timeout` or `kill`) ends its output with
`process 0 got signal 15` and no further message; under Slurm a `process 0 got signal 2` line follows, as described
above. Give long jobs enough wall time: in a version 25 test, the analytic Hessian of a 22-atom copper complex with L2 basis and a fine grid did not finish within an hour on one
core, after a 6-step optimization that had taken most of that hour.
<!-- src: 08 t72 (timeout kill); 08 Slurm tests (s02, s04) -->


(running-windows-parallel)=
## Parallel runs on Windows

The official site shows this command for a two-process run:

```bat
mpirun.exe -np 2 p.exe C60.qm.in C60.qm.w.2.out
```

The current index has no `p.exe`: use `p_190306.exe` in place of `p.exe`, here and in the commands below.

The MPI runtime is not on the site. Users assembled it from Cygwin as follows:
<!-- src: 01 §2.1; 04 #365, #370, #397, #472 -->

1. Download the 64-bit Cygwin installer (`setup-x86_64.exe` from <https://cygwin.com>). Install the default packages
   plus the `openmpi` package.
2. Copy these files from the Cygwin installation into the directory with the Priroda executable:
   `cygwin1.dll`, `cyggcc_s-seh-1.dll`, `cygmpi-12.dll`, `cygopen-pal-13.dll`, `cygopen-rte-12.dll`, `orterun.exe`.
   Take `cygwin1.dll` from the same installation, because the other DLLs work only with matching versions.
   After this, Cygwin itself is no longer needed.
3. Create a directory `dev` one level above the directory that holds `cygwin1.dll`, with subdirectories `shm` and
   `mqueue`. For Priroda in `C:\Priroda`, that means `C:\dev\shm` and `C:\dev\mqueue`. The Cygwin libraries take the
   parent of the directory that holds `cygwin1.dll` as the root `/`: with the DLL in `C:\Priroda`, `C:\Users` is
   `/Users`.
4. If the program is in a system directory such as `C:\Program Files`, run it as administrator.
5. Set `TMPDIR` and start the run from `cmd.exe`, giving the path of the Priroda executable with forward slashes:

   ```bat
   cd /d C:\Work
   set "TMPDIR=%TEMP%"
   C:\Priroda\orterun.exe -np 2 C:/Priroda/p_190306.exe file.in file.out
   ```

<!-- src: 04 #370, #397, #472; 08 w02b, w13a -->

:::{important}
`p_190306.exe` needs exactly the files `cygmpi-12.dll`, `cygopen-pal-13.dll` and `cygopen-rte-12.dll`. Current
Cygwin OpenMPI packages ship `cygmpi-40.dll`, `cygopen-pal-40.dll` and `cygopen-rte-40.dll` instead. With those,
or with those copied under the old names, the program and `orterun.exe` exit at once with code -1073741515
(0xC0000135, a required DLL was not found), and nothing is printed. A test in 2026 worked with the `-12`/`-13` files
and `orterun.exe` from an older OpenMPI package (files dated 2016-06-21). Take `orterun.exe` from the same package
as the DLLs.
:::
<!-- src: 08 w13 -->

To get the old files, install Cygwin from an archived snapshot instead of the current one. The Cygwin installation
page (<https://cygwin.com/install.html>) lists archived snapshots for old Windows versions. The 2016 x86_64 snapshot
there worked:

```bat
setup-x86_64.exe --allow-unsupported-windows --no-verify --site http://ctm.crouchingtigerhiddenfruitbat.org/pub/cygwin/circa/64bit/2016/08/30/104235
```

Select the `openmpi` package, then copy the files listed in step 2 from the `bin` directory of that installation.
<!-- src: 08 w13 (snapshot from the owner's report; options from cygwin.com/install.html) --> <!-- verify: exact snapshot not recorded -->

That test ran on Windows 10 with the old Cygwin installed. `p_190306.exe` then printed
`parallel on 2 processors` and gave the same energy as a serial run. With a backslash path to the executable
(`C:\Priroda\p_190306.exe`), `orterun.exe` stopped with `orterun:exe-not-found`. Started directly, without
`orterun.exe`, `p_190306.exe` runs serially.
<!-- src: 08 w13a, w13b -->

Problems reported with this setup:

- The recipe needs a Priroda build that supports parallel runs. Version 6 (`p6.exe`) failed with an OpenMPI
  `agent-not-found` error; the user was advised to use version 17 or later. <!-- src: 04 #398, #401 -->
- On a computer connected by Wi-Fi that also has a wired network adapter, OpenMPI stops with
  `tcp_peer_send_blocking: send() to socket 12 failed: Transport endpoint is not connected (128)`. Disable the wired
  adapter. <!-- src: 04 #397 -->
- With the Ethernet cable unplugged, one user's run used only two of the cores. <!-- src: 04 #374 -->
- `Warning: '/dev/shm' does not exists or is not a directory.` means the Cygwin environment is missing. Create the
  `dev` directories (step 3), or start from a Cygwin shell. <!-- src: 04 #360, #370 -->

A user reported in 2021 that this recipe no longer worked on Windows 10 with a current Cygwin, and no fix was posted.
The likely cause is the newer OpenMPI DLLs described above. The serial build was tested on a PC without Cygwin;
the parallel run was tested only with the old Cygwin installed.
<!-- src: 04 #472; 08 w13 (likely cause inferred) -->
