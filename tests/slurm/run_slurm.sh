#!/bin/bash
# Batch-system tests on a single-node Slurm (see setup_slurm.sh). Run as your normal user, not root:
#   PRIRODA=/path/to/p MPIEXEC=/path/to/mpiexec BASIS=/abs/path/to/basis.in ./run_slurm.sh            # all
#   PRIRODA=... MPIEXEC=... BASIS=... ./run_slurm.sh s01 s05                                            # selected
# Optional: SCRATCH_BASE (default /tmp/priroda-slurm; stands in for a cluster's node-local scratch), NP (default 2).
# Outputs go to ../runs/slurm-<date>/<test>/: mol.in, mol.out, slurm-<id>.out, and job.txt (scontrol show job).
# The whole run takes about 10-15 minutes; s02-s04 use a Cu complex that runs for several minutes.
set -u
: "${PRIRODA:?set PRIRODA to the Priroda executable}"
: "${MPIEXEC:?set MPIEXEC to the mpiexec from the official site}"
: "${BASIS:?set BASIS to the absolute path of basis.in}"
command -v sbatch > /dev/null || { echo "sbatch not found: install Slurm first (sudo ./setup_slurm.sh)"; exit 1; }
here=$(cd "$(dirname "$0")" && pwd)
out="$here/../runs/slurm-$(date +%Y%m%d-%H%M%S)"
export PRIRODA MPIEXEC SCRATCH_BASE=${SCRATCH_BASE:-/tmp/priroda-slurm}
NP=${NP:-2}
mkdir -p "$out" "$SCRATCH_BASE"
log="$out/status.txt"
note() { echo "$*" | tee -a "$log"; }
selected() { local id=$1; shift; [ $# -eq 0 ] && return 0; for s in "$@"; do [[ $id == "$s"* ]] && return 0; done; return 1; }

# submit <test> <input> <script> [sbatch options...]: prepare runs/<test>/mol.in and submit from there; prints the job id
submit() {
  local t=$1 inp=$2 script=$3; shift 3
  mkdir -p "$out/$t"
  sed "s|@BASIS@|$BASIS|" "$here/../inputs/$inp" > "$out/$t/mol.in"
  (cd "$out/$t" && sbatch --parsable --ntasks="$NP" "$@" "$here/$script")
}
state() { squeue -h -j "$1" -o %T 2>/dev/null; }
# finish <test> <job id>: wait for the job to leave the queue, then record its final state and the scratch left over
finish() {
  local t=$1 id=$2
  while [ -n "$(state "$id")" ]; do sleep 5; done
  scontrol show job "$id" > "$out/$t/job.txt" 2>&1
  note "$t job $id: $(grep -o 'JobState=[A-Z_]* Reason=[^ ]*' "$out/$t/job.txt") $(grep -o 'ExitCode=[0-9:]*' "$out/$t/job.txt" | head -1) $(grep -o 'RunTime=[0-9:-]*' "$out/$t/job.txt")"
  if [ -d "$SCRATCH_BASE/$id" ]; then
    note "$t scratch left: $SCRATCH_BASE/$id: $(ls -A "$SCRATCH_BASE/$id" | tr '\n' ' ')"
    ls -la "$SCRATCH_BASE/$id" > "$out/$t/scratch_left.txt"; rm -rf "${SCRATCH_BASE:?}/$id"
  else note "$t scratch removed"; fi
}
# cancel_after <test> <job id> <seconds>: wait until the job runs, let it run for <seconds>, then scancel it
cancel_after() {
  local t=$1 id=$2 s=$3
  while [ "$(state "$id")" = PENDING ]; do sleep 2; done
  sleep "$s"
  if [ "$(state "$id")" = RUNNING ]; then
    ls -A "$SCRATCH_BASE/$id" > "$out/$t/scratch_before_cancel.txt" 2>&1
    scancel "$id"; note "$t job $id cancelled after ${s} s"
  else note "$t job $id ended before the cancel (too short for this machine)"; fi
}

note "Slurm $(sinfo --version) on $(hostname -s); NP=$NP; SCRATCH_BASE=$SCRATCH_BASE"
sinfo > "$out/sinfo.txt"

# s01: the manual's script as written: does SLURM_NTASKS reach mpiexec, does the scratch go to the job's TMPDIR
#      (Disk: echo), and is it removed at the end?
if selected s01 "$@"; then id=$(submit s01 s01_water.in manual.sbatch); finish s01 "$id"; fi
# s02: the manual's script, job cancelled with scancel while the SCF runs: what does mol.out end with
#      (signal 15?), and is the scratch left behind (the rm at the end of the script never runs)?
if selected s02 "$@"; then id=$(submit s02 s02_cu_energy_long.in manual.sbatch); cancel_after s02 "$id" 60; finish s02 "$id"; fi
# s03: the same with manual_trap.sbatch: does the trap remove the scratch after scancel?
if selected s03 "$@"; then id=$(submit s03 s02_cu_energy_long.in manual_trap.sbatch); cancel_after s03 "$id" 60; finish s03 "$id"; fi
# s04: time limit of 1 minute (manual's script): what do mol.out and slurm-<id>.out show when Slurm kills the job?
if selected s04 "$@"; then id=$(submit s04 s02_cu_energy_long.in manual.sbatch --time=1); finish s04 "$id"; fi
# s05: two single-process jobs at the same time (water): do both run at once and finish with separate scratch?
if selected s05 "$@"; then
  a=$(submit s05a s01_water.in manual.sbatch --ntasks=1); b=$(submit s05b s01_water.in manual.sbatch --ntasks=1)
  sleep 3; squeue > "$out/s05_queue.txt"
  finish s05a "$a"; finish s05b "$b"
fi

note "Outputs in $out"
