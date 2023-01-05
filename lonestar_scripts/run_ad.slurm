#!/bin/sh
##SBATCH -o myjob.o%j       # Name of stdout output file
##SBATCH -e myjob.e%j       # Name of stderr error file
#SBATCH -p normal          # Queue (partition) name
#SBATCH -N 1               # Total # of nodes
#SBATCH -n 108              # Total # of mpi tasks
#SBATCH -t 01:30:00        # Run time (hh:mm:ss)
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH -A DPP22001        # Project/Allocation name (req'd if you have more than 1)
#SBATCH --mail-user=dan.goldberg@ed.ac.uk

source ~/.bashrc
module purge
module load intel/19.1.1 impi/19.0.9 netcdf/4.6.2
module load petsc/3.15-uni

cd $SLURM_SUBMIT_DIR/../run_ad

bash opt_script.csh

exit
