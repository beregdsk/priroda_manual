#!/bin/bash
# The SLURM script from running.md ("Batch systems"), corrected after the first test (env -i, exit status),
# and unchanged otherwise, except that the three site-specific paths can be
# set from the environment (run_slurm.sh does that): PRIRODA, MPIEXEC and SCRATCH_BASE.
#SBATCH --job-name=mol
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --time=24:00:00

PRIRODA=${PRIRODA:-$HOME/priroda/p}                       # full path to the executable
cd "$SLURM_SUBMIT_DIR"
export TMPDIR=${SCRATCH_BASE:-/local/scratch}/$SLURM_JOB_ID   # node-local disk; site-specific
mkdir -p "$TMPDIR"

# The official mpiexec refuses to start when the environment has 193 or more variables ("Environment is too large"),
# and a Slurm job has many. env -i starts it with only the variables it needs.
env -i PATH="$PATH" HOME="$HOME" TMPDIR="$TMPDIR" \
  ${MPIEXEC:-$HOME/priroda/mpiexec} -np "$SLURM_NTASKS" "$PRIRODA" mol.in mol.out   # the mpiexec from the official site
status=$?

rm -rf "$TMPDIR"
exit $status                                  # report Priroda's exit status, not that of rm
