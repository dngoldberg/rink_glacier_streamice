#!/bin/sh --login
################################################################################
# Run the model for as long as we can, then prepare for a restart and submit the next job.
################################################################################
##PBS -l select=2
##PBS -q short
##PBS -l walltime=00:20:00
#PBS -l walltime=4:00:00
#PBS -l select=8:ncpus=36:mpiprocs=36
# Parallel jobs should always specify exclusive node access
#PBS -l place=scatter:excl
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
#module load leave_time
module load intel-mpi-18
module load intel-compilers-18

cd $PBS_O_WORKDIR/../run

timestep=100
#tottime=186624000
tottime=186624000
maxntime=155520

rm data

ln -s ../input/* .
ln -s ../build/mitgcmuv .

s=$(ls -tr pickup.0*meta | tail -n 1)
echo $s
if [ ! -z "$s" ]; then
 IFS='.' tokens=( $s )
 old=${tokens[1]}
 new=$(echo $old | sed 's/^0*//')
 new2=" niter0=$new"
 new3=" deltaT=$timestep"
 ntime=$(($tottime/$timestep-$new))
 if (( $ntime > $maxntime )); then
  ntime=$maxntime
 fi
 new4=" nTimesteps=$ntime"
else
 new2=" niter0=0"
 new=0
 new3=" deltaT=$timestep"
 ntime=$(($tottime/$timestep-$new))
 if (( $ntime > $maxntime )); then
  ntime=$maxntime
 fi
 new4=" nTimesteps=$ntime"
fi
echo $new2
echo $new3
echo $tottime
echo $timestep
echo $new
echo $ntime
sed "s/.*niter0.*/$new2/" data > data.temp
sed "s/.*deltaT.*/$new3/" data.temp > data.temp2
sed "s/.*nTimesteps.*/$new4/" data.temp2 > data.temp3
mv data.temp3 data

if (( $ntime > 0 )); then
 mpirun -n 288 -ppn 36 ./mitgcmuv
 OUT=$?
else
 OUT=-1
fi

s=$(ls -tr pickup.0*meta | tail -n 1)
echo $s
if [ ! -z "$s" ]; then
 IFS='.' tokens=( $s )
 old=${tokens[1]}
 new3=$(echo $old | sed 's/^0*//')
else
 new3=0
fi

if (( $new3 > $new )); then
 cp STDOUT.0000 stdout_$new3
 cd ../scripts
 qsub -N $PBS_JOBNAME -A $HECACC rput_dsn.sh
 if [ $OUT == 0 ]; then 
  qsub -N $PBS_JOBNAME -A $HECACC run_repeat.sh
 fi
else
  echo "no new pickup found"
fi

exit
