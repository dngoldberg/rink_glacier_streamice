#!/bin/bash --login
################################################################################
# Run the model for as long as we can, then prepare for a restart and submit the next job.
################################################################################
#PBS -l select=3
##PBS -q short
##PBS -l walltime=00:20:00
#PBS -l walltime=10:00:00
#PBS -e ../run
#PBS -o ../run
#PBS -j oe
#PBS -m bea
#PBS -M dan.goldberg@ed.ac.uk
#PBS -r n

# hardwire budget if you wish to over-ride default
#export HECACC=n02-NEI025867
#export HECACC=n02-NEM001660

echo "GOT HERE RUN REPEAT"
module load leave_time

cd $PBS_O_WORKDIR/../run_ad

#export TMPDIR=/work/n02/n02/`whoami`/SCRATCH
export OMP_NUM_THREADS=1

# Directory to save copies of pickups in
OUT_DIR="pickups"

# start timer
timeqend="$(date +%s)"
elapsedqueue="$(expr $timeqend - $TIMEQSTART)"
timestart="$(date +%s)"
echo >> times
echo Queue-time seconds $elapsedqueue >> times
echo Run start `date` >> times


# Run the job but leave 1 minute at the end
#leave_time 60 aprun -n 480 -N 24 ./mitgcmuv
aprun -n 72 -N 24 ./mitgcmuv_ad > out.txt 2> err.txt
# Get the exit code

