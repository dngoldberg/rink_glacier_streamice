#!/bin/bash
################################################
# Start a self-resubmitting simulation.
################################################

# ID number for run
JOBNO=00

# clean run directory and link all required files

# record start times
TIMEQSTART="$(date +%s)"
echo Start-time `date` >> times

./prepare_run_ad.sh 

echo $JOBNO
echo $TIMEQSTART
echo $HECACC
# submit the job chain
sbatch --job-name=ice_$1 -A n02-PROPHET run_ad.slurm 
#qsub -A $HECACC run.sh
