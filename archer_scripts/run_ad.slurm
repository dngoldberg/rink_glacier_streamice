#!/bin/sh
#SBATCH --time=1:00:00
#SBATCH --exclusive
#SBATCH --nodes=1
#SBATCH --tasks-per-node=108
#SBATCH --cpus-per-task=1
#SBATCH --partition=standard
#SBATCH --qos=standard
##SBATCH --reservation=shortqos


module load PrgEnv-gnu
module swap cray-mpich  cray-mpich/8.1.4
module load cray-hdf5-parallel/1.12.0.3
module load cray-netcdf-hdf5parallel/4.7.4.3

cd $SLURM_SUBMIT_DIR/../run_ad

bash opt_script.csh

exit
