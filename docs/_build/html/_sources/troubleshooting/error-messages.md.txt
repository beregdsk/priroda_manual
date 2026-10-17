(troubleshooting.error-messages)=
# Error message index

This index lists every error and warning message that users have quoted in the forums and pages used for this
manual, together with the context in which it appeared, its cause, and the fix. The messages are copied as users
posted them. Numbers inside a message (file names, array sizes, process IDs) change from run to run; they are shown
either as in the original report or as `<N>`.

Entries are sorted alphabetically by message text. The sort ignores case, the rank prefix `0:` that Priroda puts in
front of messages from process 0, and leading punctuation such as `***`. Each entry says how well its fix is
supported:

- **confirmed** means that the user who had the problem, or several users, reported that the fix worked;
- **single report** means that one user, usually an experienced one, posted the fix and nobody confirmed it.

Messages from MPI, Cygwin and the shell, which Priroda does not print itself, have their own section. Messages for
which no fix is known are collected under {ref}`troubleshooting.unresolved`. For problems that print no message at
all (silent hangs, ignored settings, wrong results), see {ref}`troubleshooting.common-problems`.

:::{note}
Most of these reports come from Priroda 6 to 17 (2009–2018). Messages and behaviour in current builds may differ,
and none of the entries has yet been reproduced with a current binary.
:::

## Messages printed by Priroda

### `application called MPI_Abort(MPI_COMM_WORLD, 1) - process 0`

The run stops with this line from the MPI library. Two causes are known; a third case is under
{ref}`troubleshooting.unresolved`.

1. **Hybrid functional with `theory=dft`.**
   - **Context:** 2014 builds. The output shows `Basis set input: './basis.in'` twice and then stops; the summary box
     (`| Number of atoms`) never appears. Happens with B3LYP or PBE1 under `theory=dft`.
   - **Cause:** hybrid functionals are supported only with `theory=ridft`. Older versions ran such input without a
     message and silently dropped the exact exchange.
   - **Fix:** use {ref}`theory=ridft <control.theory>`. See {ref}`troubleshooting.hybrid`.
   - **Support:** confirmed by several users (the same sample input ran with `ridft` and failed with `dft`).
   <!-- src: 04 #307-#310; 04 §17 pages 13-16 -->
2. **Relative paths in a parallel run.**
   - **Context:** Linux, 2012, run started through the bundled `mpiexec`. The output stopped after the list of nodes
     while all cores stayed at 100%.
   - **Cause:** the basis file was given by a relative path.
   - **Fix:** start the binary itself with `-np N` and give absolute paths for the binary, the input, the output and
     the basis file inside the input.
   - **Support:** single report (the user who had the problem).
   <!-- src: 04 #150-#154 --> <!-- verify -->

### `Basis set input: 'basis4.bas'   1?`

- **Context:** Windows, 2013, relativistic basis file `basis4.bas` / `basis4.in`. The job stops at this line.
- **Cause:** the scalar-relativistic Hamiltonian was not switched on.
- **Fix:** add {ref}`four=1 <control.four>` to {ref}`$control <group.control>`.
- **Support:** confirmed by the user who had the problem.
<!-- src: 04 #206-#208; 04 §15 -->

### `Cannot open input file '<path>'.`

- **Context:** Linux, 2012; the user's command line was
  `./p6_64.bin /home/quantum/pridoda/task.in /home/quantum/priroda/task.out`.
- **Cause:** the input file did not exist at that path (here the directory name was misspelled, and the parent
  directory did not exist either).
- **Fix:** check the path with `ls -l`; work in a directory you own, `cd` into it and run
  `./p task.in task.out`. See {ref}`troubleshooting.input`.
- **Support:** resolved in the thread.
<!-- src: 04 #159-#171 -->

For the Windows message `cannot open input file`, see {ref}`troubleshooting.unresolved`.

### `dipole =   0.000000 au (  0.000000 D)`

- **Context:** version 6, relativistic basis sets; the dipole was zero for every molecule, even with `task=dipole`.
- **Cause:** a limitation of version 6.
- **Fix:** upgrade; version 8 and later print a value.
- **Support:** two users.
<!-- src: 04 #32-#35 -->

### `*** error in '$scf' : unknown name erations`

- **Context:** 2015 builds, `$scf` containing both `iterations=` and `convergence=` (for example
  `$scf restrict=0 procedure=BFGS iterations=999,999 convergence=1e-10 $end`).
- **Cause:** a parser problem with this pair of keywords. One user found that the group was read only when
  `iterations` came before `convergence`; another got this error in either order. A third report says the pair works
  only together with `procedure=bfgs`.
- **Fix:** put `iterations` before `convergence`, on separate lines, and check the `scf options:` line in the output
  to see whether both values were read. See {ref}`convergence <scf.convergence>`.
- **Support:** the reports conflict; not confirmed.
<!-- src: 05 §5.1, §17; 04 #322-#324 --> <!-- verify -->

### `error opening file ''3z.bas''`

- **Context:** IRC input, 2010.
- **Cause:** the basis file name was enclosed in two single quotes.
- **Fix:** use one pair of straight double quotes, `basis="3z.bas"`, or an unquoted absolute path. Typographic quotes
  copied from a document fail too.
- **Support:** single report for this message; the quoting rule is repeated by several users.
<!-- src: 03 §2 (denis, Evgeniy, sanya, amg); 04 #64 -->

### `For all methods the performance will be degraded terribly if more than one process read and write large files on the same physical drive!`

- **Context:** quoted in a 2014 forum post as a warning, by a user running 16 processes with all scratch on one
  disk. The same sentence, with "except GGA DFT" after "For all methods", is a note in the `input.txt` keyword list,
  so the post may have quoted the documentation rather than program output.
- **Cause:** all processes write their scratch files to the same physical drive.
- **Fix:** give each process its own drive with a colon-separated {ref}`path <system.path>` list, or keep scratch
  in RAM with a negative {ref}`disk <system.disk>` value. If neither is possible, the run still works, only slower.
  See {ref}`troubleshooting.memory`.
- **Support:** the documentation gives the same advice.
<!-- src: 04 #293; input.txt lines 39-41 --> <!-- verify: is this printed by the program at all? -->

### `h = -25.15!`

- **Context:** SCF table of a diverging DFT run (2014, energy about −2800 hartree). Preceded by `hmin = ...` values
  that grow in magnitude.
- **Cause:** the SCF is running away.
- **Fix:** cap the SCF at `iterations=10`, save the vectors with `$control save=`, restart with `$guess read=1`, and
  repeat. See {ref}`troubleshooting.scf`.
- **Support:** the restart technique is recommended by experienced users on both forums; the asker did not report
  the outcome.
<!-- src: 04 #305, #306; 03 §7 -->

### `lowest eigenvalue = <N>!!!`

- **Context:** Priroda 6 on Windows, 2015. Large negative values (`-1814.64!!!`, `-788121.66!!!`) from the first
  iteration on; the energy rose every macro-iteration and the run ended with `no convergence!` and
  `SCF is far from convergence`.
- **Cause:** not established. Likely contributors in the reported case: a non-native basis with diffuse functions,
  the hybrid B3LYP with `theory=DFT`, `mult=0` for an odd number of electrons, and a poor starting geometry.
- **Fix:** correct the input first (multiplicity, `theory=ridft` for hybrids, a native basis, a sensible geometry),
  then try `procedure=bfgs` with more iterations and a finer grid. See {ref}`troubleshooting.scf`.
- **Support:** suggestions from two experienced users; the asker did not report back.
<!-- src: 04 #319-#321; 04 §8 (multiplicity point is the note author's analysis) --> <!-- verify -->

### `0: malloc(<N>) failed`

- **Context:** seen as `malloc(536870912) failed`, `malloc(1678770176) failed.` and, on a cluster,
  `0: malloc(<N>) failed`. The number is the request in bytes.
- **Cause:** Priroda could not allocate what {ref}`memory <system.memory>` (plus a RAM disk from a negative
  {ref}`disk <system.disk>`) asked for. The 32-bit Windows (Cygwin) builds cannot allocate more than about 1 GB.
- **Fix:** ask for less than the machine has free. With a RAM disk, `memory` + |`disk`| (MB), times the number of
  processes, must fit in physical RAM; for example `memory=9000 disk=-14000` on a 24 GB node. On 32-bit Windows,
  use at most about 1000 MB (512 MB was enough for most DFT jobs), or use a 64-bit build. See
  {ref}`troubleshooting.memory`.
- **Support:** confirmed by several users.
<!-- src: 04 #58, #94, #95, #104, #105, #210, #211, #462-#471 -->

### `malloc: using debugging hooks`

- **Context:** Linux, 2012, first line on the terminal. In one case it was followed by
  `[0] MPI Abort by user Aborting program !` and `[0] Aborting program!`.
- **Cause:** on its own the line is harmless; one run that printed it was simply still running, and its output file
  appeared later. The abort lines appeared when the input file could not be found.
- **Fix:** if the abort lines follow, check the paths of the input and output files (see
  {ref}`troubleshooting.input`).
- **Support:** single thread.
<!-- src: 04 #161, #170, #172 --> <!-- verify -->

### `molecule input: ''`

Priroda prints this line before it reads the molecule. When the run stops right after it, the next lines tell the
cause.

1. **Followed by a mangled keyword and `?`**, for example `' ?matrix`, `?rtesian` or `'z-matrix' ?`.
   - **Cause:** the input has Windows (CRLF) line endings, or was saved as Unicode or from Word.
   - **Fix:** convert to plain text with Unix line endings (`dos2unix input.in`). Avoid Cyrillic letters and spaces in
     host, directory and file names.
   - **Support:** confirmed by several users.
   <!-- src: 04 #63-#65, #104, #113; 03 §2 (Dimylko, amg) -->
2. **Followed by `illegal charge/multiplicity`.**
   - **Cause:** atomic numbers written as real numbers (`25.0`) in `$molecule`.
   - **Fix:** write atomic numbers as integers.
   - **Support:** single report.
   <!-- src: 03 §5 (Evgeniy, Aug 2011) --> <!-- verify -->
3. **Followed by `'cartesian` and `' ?`**, together with `OOPS: semop lock failed 98304`.
   - **Context:** Linux, 2012, normal user; the same input worked on Windows and as root.
   - **Cause:** probably CRLF line endings (the line break after `cartesian` points to a stray carriage return).
   - **Fix:** `dos2unix`; `chmod +r` on the input files was also suggested.
   - **Support:** not confirmed; the thread does not say whether it was fixed.
   <!-- src: 04 #172-#174 --> <!-- verify -->

### `no convergence!`

- **Context:** printed when the SCF reaches its iteration limit without converging. It is usually followed by
  `SCF is far from convergence`.
- **Fix:** see {ref}`SCF is far from convergence <troubleshooting.msg-scf-far>`.
<!-- src: 02 §3.3; 04 #319 -->

### `OOPS: semop lock failed`

- **Context:** shared-memory runs. Reported (a) in v6 on 7 cores during a DFT optimization, together with
  `process N received signal 2` or `6`; (b) after another fatal error, for example
  `0: out of disk space (VNNNN), 18067356KB`; (c) on Linux for a normal user but not for root
  (`OOPS: semop lock failed 98304`).
- **Cause:** a failure of the semaphores used between processes. In case (b) it is only a consequence of the first
  error.
- **Fix:** (a) use fewer cores (in v6, at most 4 for an optimization and 2 for a Hessian); cleaning up semaphores
  with `ipcrm` did not help. (b) fix the first error. (c) unresolved.
- **Support:** (a) and (b) each from one thread. See {ref}`troubleshooting.parallel`.
<!-- src: 03 §8 (denis), §15 (Chai, Evgeniy); 04 #172-#174 --> <!-- verify -->

### `0: opening file /tmp/tmpNNNN.0`

- **Context:** Windows builds (2009). The output ends here, just after the `System options` block shows
  `Disk:   1 GB '/tmp'`.
- **Cause:** no scratch directory was set, and Windows has no `/tmp`.
- **Fix:** add `$system path=. $end` (or `path=/cygdrive/c/temp`), or set the `TMPDIR` environment variable. See
  {ref}`path <system.path>`.
- **Support:** confirmed by several users.
<!-- src: 03 §2 (#0, GemmaNC); 04 #20, #21, #128 -->

### `0: out of disk space (VNNNN), <N>KB`

- **Context:** conventional MP2 runs (2010), and a correlated Hessian on 16 processes (2014). Variants seen:
  `0: out of disk space (VNNNN), 184441541KB`, `0: out of disk space (VNNNN), 542865328` and
  `0: out of disk space (ci.Rnvvo), 553912160`.
- **Cause:** the job needs more scratch than {ref}`disk <system.disk>` allows. The limit is per process.
- **Fix:** raise `disk=`; for MP2, use `theory=rimp2` instead of conventional MP2; check that `cartesian` or
  `z-matrix` matches the coordinates actually given. See {ref}`troubleshooting.memory`.
- **Support:** confirmed; the 2014 Hessian ran after `disk` was raised to 40 GB.
<!-- src: 03 §4; 04 #289, #290; 04 §19 (disk=40) -->

### `0: output file 'tasK.out'?`

- **Context:** Linux, 2012, printed when the output file name contained capital letters.
- **Cause:** not known.
- **Fix:** use lower-case file names.
- **Support:** single observation, not explained.
<!-- src: 04 #161 --> <!-- verify -->

### `process 0 got signal 6`

- **Context:** geometry optimization, 2026. On the last step the `INTERNAL COORDINATES` table ends with `too few`.
- **Cause:** the optimizer could not build a valid set of internal coordinates.
- **Fix:** `$optimize cartesian=1 $end` (see {ref}`cartesian <optimize.cartesian>`).
- **Support:** single report (answer by an experienced user; the asker did not report back).
<!-- src: 04 #517, #518 --> <!-- verify -->

### `0: read file ./tmp/tmpNNNN.0 (VNNNN): fd=3 buf=<address> siz=8 lpos=0`

- **Context:** conventional MP2, 2010.
- **Cause:** given the same diagnosis as `out of disk space`: not enough scratch.
- **Fix:** as for {ref}`out of disk space <troubleshooting.memory>`.
- **Support:** single report.
<!-- src: 03 §4 (Marsel, Evgeniy) --> <!-- verify -->

(troubleshooting.msg-scf-far)=
### `SCF is far from convergence`

- **Context:** the SCF has used up its `iterations` and the gradient is still large; Priroda stops. Reported with
  diverging DFT runs, non-native or diffuse basis sets, and transition-metal complexes.
- **Cause:** see the possible causes in {ref}`troubleshooting.scf`.
- **Fix:** check the input (multiplicity, `theory=ridft` for hybrids, native basis, reasonable geometry). Then restart
  from the saved vectors (`iterations=10`, `$control save=`, `$guess read=1`, repeat), or switch the SCF procedure:
  `$scf convergence=1e-7 procedure=bfgs iterations=250 $end` with `$grid accuracy=1e-9 $end`.
- **Support:** the restart technique is recommended by several experienced users and automated in the limor1 `pri`
  script; neither fix was confirmed by the users who asked.
<!-- src: 04 #306, #319-#321; 02 §5.3; 03 §7 -->

### `Solving for responses ...`

- **Context:** not an error: the run hangs at this step. Version 6, analytic Hessian on 4 cores.
- **Cause:** limited parallel support in version 6.
- **Fix:** use at most 2 cores for a v6 Hessian; better, use version 16 or later.
- **Support:** single source; another user ran DFT Hessians on 24–32 cores without trouble.
<!-- src: 03 §3, §15 (Evgeniy, sanya); 04 #401 --> <!-- verify -->

### `Vicinity of a Stationary Point(?) --- STOP.`

- **Context:** first point of an IRC (2014), followed by `IRC> point   1: distance = ...` and a `REACTION PATH` with
  a single point.
- **Cause:** the energy did not decrease on that step.
- **Fix:** change the IRC step ({ref}`radius <optimize.radius>`): larger for a very flat barrier top, smaller for a
  narrow barrier such as a proton transfer.
- **Support:** single report (experienced user).
<!-- src: 04 #295, #298 --> <!-- verify -->

### `0: write VMNN(<N>:<N>)?`

- **Context:** seen as `0: write VMNN(11753704:14042536)?`. A 7-atom RI-MP2 energy with `four=1`, `basis4.in` and
  `set=L22` (2015). The same job also reported that it did not fit in memory, whatever memory was given.
- **Cause:** apparently a bug in the stored-integral RI-MP2 path for some basis and size combinations.
- **Fix:** `$integral direct=1 $end` (see {ref}`direct <integral.direct>`).
- **Support:** two users reproduced the problem and the workaround.
<!-- src: 05 §4.2, §17 -->

## Messages from MPI, Cygwin and the shell

### `chown: cannot access '/home/username/.gvfs': Permission denied`

- **Context:** printed by `chown -R` run as root on a home directory while fixing file permissions (Linux, 2012).
- **Cause:** a GVFS mount point that even root cannot enter.
- **Fix:** none needed; it is harmless and unrelated to Priroda.
<!-- src: 04 #172; 04 §17 -->

### `Error in system call mpiexec: No such file or directory`

- **Context:** Linux, 2012, Priroda started as `mpiexec -np 4 p file.in file.out`. Also seen:
  `mpiexec could not exec p`.
- **Cause:** the binary was not found through the bundled `mpiexec`.
- **Fix:** start the Priroda binary itself, which takes `-np`: `./p -np 4 file.in file.out`, with absolute paths if
  needed.
- **Support:** confirmed by the user who had the problem.
<!-- src: 04 #150, #153, #154 -->

### `If 'p6_64' is not a typo you can use command-not-found ...`

- **Context:** Linux shell, 2012.
- **Cause:** the current directory is not in `PATH`.
- **Fix:** run the binary as `./p6_64 ...` or by its full path.
<!-- src: 04 #152, #153 -->

### `Sorry!  You were supposed to get help about: agent-not-found`

- **Context:** Windows, Cygwin OpenMPI 3.1.3, 2018, command `orterun.exe -np 2 p6.exe test.in test.out`. The
  output continues with `[[INVALID],INVALID] FORCE-TERMINATE AT Not found:-13` and a segmentation fault.
- **Cause:** the user was running version 6, which has no parallel support of this kind.
- **Fix:** use version 16 or later (version 17 was recommended).
- **Support:** single report; the asker did not report back.
<!-- src: 04 #398, #401 --> <!-- verify -->

### `tcp_peer_send_blocking: send() to socket 12 failed: Transport endpoint is not connected (128)`

- **Context:** Windows, Cygwin OpenMPI parallel run (2018) on a PC connected by WiFi that also had a LAN adapter.
- **Fix:** disable the unused LAN adapter.
- **Support:** single report.
<!-- src: 04 #397 --> <!-- verify -->

### `Warning: '/dev/shm' does not exists or is not a directory.`

- **Context:** Windows 10 with Cygwin (2016); printed when Priroda was started from `cmd.exe` but not from the Cygwin
  shell.
- **Cause:** outside the Cygwin shell, the Cygwin libraries do not find their environment.
- **Fix:** start from the Cygwin shell, or create `dev\shm` and `dev\mqueue` one directory above the one Priroda
  starts from. See {ref}`troubleshooting.parallel`.
- **Support:** recipe from two experienced users.
<!-- src: 04 #360, #362, #370 -->

(troubleshooting.unresolved)=
## Unresolved

No fix is known for the following messages. Where a reply suggested a direction, it is given, but nobody reported
that it worked.

### `application called MPI_Abort(MPI_COMM_WORLD, 1) - process 0` during `task=anharmonic`

- **Context:** 2011, `task=anharmonic` with `four=1` and `basis4.in`. The run died after the first displacement, at
  the line `Scalar Relativistic Density Functional Calculation:`.
- **Notes:** no reply. The `four=1` combination may be involved; this is a guess.
<!-- src: 03 §10, §15 (Llewule) -->

### `cannot open input file`

- **Context:** Windows, 2011, `p6.exe input.in output.out` with the executable, `cygwin1.dll`, the inputs and the basis
  folder in one directory.
- **Notes:** changing to that directory first did not help. Other users pointed to a launcher script that sets
  `TMPDIR` and changes to the program directory, and to input encoding (Word, Unicode, CRLF). The thread never found
  the cause.
<!-- src: 04 #130-#133 -->

### `MMDYNAMIC  need 'mmdata'`

- **Context:** version 9, the undocumented `MMDYNAMIC` task.
- **Notes:** the task needs a molecular-mechanics data file that is not distributed.
<!-- src: 03 §5, §15 (amg) -->

### `process 0 received signal 1`

- **Context:** DFT on a Pt complex with an `rL33` relativistic basis (2010); the SCF table showed `hmin = -0.302`.
- **Notes:** one user suggested checking that the basis table has no zero entries, that is, that every element is
  present in the chosen set. Another user's H2 RI-MP2 test with the L33 basis worked.
<!-- src: 03 §15 (Marsel, Evgeniy) -->

### `process 0 recieved signal 11`

- **Context:** Windows, 2013, first optimization step of Hg and Os porphyrins with `3z.bas`; the Ru analogue worked.
  (The spelling `recieved` is as posted.)
- **Notes:** `3z.bas` has no relativistic corrections but should in principle work. For Hg and Os the recommended
  route is `basis4.in` with `four=1`; the crash itself was not explained.
<!-- src: 04 #206, #207 -->

### `We need 1.5 GB of memory...`

- **Context:** 2020, ordinary PC, `$system ... disk=40`. The message is quoted only up to this point.
- **Notes:** one reply suggested that it refers to RAM (`memory=`), so more disk space would not help. Not
  confirmed.
<!-- src: 04 #463, #464 --> <!-- verify -->

### `0: write file /tmp/tmpNNNN.NN (leAX): fd=<N> buf=<address> siz=<N>,<N> lpos=<N>`

- **Context:** 2020, cluster, analytic Hessian of a 142-atom chain (OLYP/4z.bas, `memory=9000 disk=40`), after
  several iterations of `ANALYTIC SECOND DERIVATIVES OF SCF ENERGY`. Seen as
  `0: write file /tmp/tmp9633.11 (leAX): fd=21 buf=0x2aaaae307e80 siz=9525120,3885400 lpos=996398760`.
- **Notes:** no direct answer. Replies in the same discussion pointed out that `path=` was not set, so scratch went
  to `/tmp`, which on a cluster may be small or quota-limited, and suggested a proper scratch directory or a RAM
  disk. A full disk or a file-size limit is a plausible cause, but this is a guess.
<!-- src: 04 #460, #462, #465; 04 §17 (unverified inference) -->
