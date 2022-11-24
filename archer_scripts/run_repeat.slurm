#!/bin/sh 
#SBATCH --time=10:00:00
#SBATCH --exclusive
#SBATCH --nodes=3
#SBATCH --tasks-per-node=36
#SBATCH --cpus-per-task=1
#SBATCH --account=sc030
#SBATCH --partition=standard
#SBATCH --qos=standard
#SBATCH --exclude=r1i0n1[0-9]

# hardwire budget if you wish to over-ride default
#export HECACC=n02-NEI025867
#export HECACC=n02-NEM001660

cd $SLURM_SUBMIT_DIR/../run

echo "GOT HERE RUN REPEAT"
#module load leave_time
#module load intel-mpi-18
module load mpt/2.22
#module load intel-compilers-18
module load intel-compilers-19


timestep=100
tottime=62208000
maxntime=103680

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
echo $new4
echo $tottime
echo $timestep
echo $new
echo $ntime
sed "s/.*niter0.*/$new2/" data > data.temp
sed "s/.*deltaT.*/$new3/" data.temp > data.temp2
sed "s/.*nTimesteps.*/$new4/" data.temp2 > data.temp3
mv data.temp3 data

if (( $ntime > 0 )); then
 srun  ./mitgcmuv > out.txt
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
 sbatch --job-name=$SLURM_JOB_NAME rput_cirrus_mds.slurm
 if [ $OUT == 0 ]; then 
  sbatch --job-name=$SLURM_JOB_NAME run_repeat.slurm
 fi
else
  echo "no new pickup found"
fi

exit
