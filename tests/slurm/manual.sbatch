#!/bin/bash
# The SLURM script from running.md ("Batch systems"), unchanged except that the three site-specific paths can be
# set from the environment (run_slurm.sh does that): PRIRODA, MPIEXEC and SCRATCH_BASE.
#SBATCH --job-name=mol
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --time=24:00:00

PRIRODA=${PRIRODA:-$HOME/priroda/p}                       # full path to the executable
cd "$SLURM_SUBMIT_DIR"
export TMPDIR=${SCRATCH_BASE:-/local/scratch}/$SLURM_JOB_ID   # node-local disk; site-specific
mkdir -p "$TMPDIR"

${MPIEXEC:-$HOME/priroda/mpiexec} -np "$SLURM_NTASKS" "$PRIRODA" mol.in mol.out   # the mpiexec from the official site

rm -rf "$TMPDIR"
