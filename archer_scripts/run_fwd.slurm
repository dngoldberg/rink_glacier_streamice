#!/bin/sh
#SBATCH --time=10:00:00
#SBATCH --exclusive
#SBATCH --nodes=2
#SBATCH --tasks-per-node=128
#SBATCH --cpus-per-task=1
#SBATCH --partition=standard
#SBATCH --qos=standard
##SBATCH --reservation=shortqos


# hardwire budget if you wish to over-ride default
#export HECACC=n02-NEI025867
#export HECACC=n02-NEM001660


#module load leave_time
#module load intel-mpi-18
#module load mpt/2.22
#module load intel-compilers-18
#module load intel-compilers-19

#module restore /etc/cray-pe.d/PrgEnv-gnu
#module swap cray-mpich  cray-mpich/8.1.3
# brings in wriogn gcc, no netcdf -  module load cray-hdf5
#module load cray-hdf5-parallel/1.12.0.2
#module load cray-netcdf-hdf5parallel/4.7.4.2

module load PrgEnv-gnu
module swap cray-mpich  cray-mpich/8.1.4
module load cray-hdf5-parallel/1.12.0.3
module load cray-netcdf-hdf5parallel/4.7.4.3

cd $SLURM_SUBMIT_DIR/../run_fwd_$1_$2

srun --distribution=block:block --hint=nomultithread ./mitgcmuv > out 2> err

exit
