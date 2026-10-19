#!/bin/bash
# manual.sbatch with the scratch clean-up moved into a trap, so that it also runs when the job is cancelled or hits
# its time limit (Slurm then sends SIGTERM to the job). Compare with manual.sbatch in tests s02/s03.
#SBATCH --job-name=mol
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --time=24:00:00

PRIRODA=${PRIRODA:-$HOME/priroda/p}
cd "$SLURM_SUBMIT_DIR"
export TMPDIR=${SCRATCH_BASE:-/local/scratch}/$SLURM_JOB_ID
mkdir -p "$TMPDIR"
trap 'rm -rf "$TMPDIR"' EXIT
trap 'exit 143' TERM

env -i PATH="$PATH" HOME="$HOME" TMPDIR="$TMPDIR" \
  ${MPIEXEC:-$HOME/priroda/mpiexec} -np "$SLURM_NTASKS" "$PRIRODA" mol.in mol.out &
wait $!
