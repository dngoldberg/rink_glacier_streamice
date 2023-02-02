#!/bin/sh

#
#
#

#nprocs=128
itermax=50
procsonnode=128


#



name=optiter
echo "Beginning of script"
echo "HERE0"
ite=`egrep 'optimcycle' data.optim | sed 's/ optimcycle=//'| sed 's/,$//'`
echo "HERE1"
echo $ite
i=`expr $ite + 1`
echo "HERE2"
echo $itermax
while [ $i -le $itermax ]
do
 echo "GOT HERE"
 ii=`./add0upto3c $i`
 echo "Beginning of iteration $ii"
 cp OPTIM/ecco_ctrl_MIT_CE_000.opt0$ii .
 ite=`expr $i - 1`
 sed "s/ optimcycle=$ite/ optimcycle=$i/" data.optim > TTT.tmp
 mv -f TTT.tmp data.optim
 fich=output$name$ii
 echo "Running mitcgm_ad: iteration $ii"
 ls mitgcmuv_ad
# mpirun -n $nprocs ./new.csh
# srun -n $nprocs -N $procsonnode ./mitgcmuv_ad
# srun --distribution=block:block --hint=nomultithread ./mitgcmuv_ad
 ibrun ./mitgcmuv_ad > out 2>err
 rm tapelev*
 rm oad_cp*
 cp STDOUT.0000 $fich
 egrep optimcycle data.optim >> fcost$name
 grep "objf_temp_tut(" $fich >> fcost$name
 grep "objf_hflux_tut(" $fich >> fcost$name
 egrep 'global fc =' $fich >> fcost$name
 grep 'global fc =' $fich
 echo Cleaning
 \rm tapelev*
 direc=run$name$ii
 mkdir $direc
 rm pickup.* pickup_*  maskCtrl* hFac* wunit* RA*ta DX*ta DY*ta DR*ta PH*ta
 mv -f *.meta *.data STDOUT* STDERR* out err scratch1.* $direc
 mv -f $direc/wunit*.*data ./
 cp -f ecco_ctrl_MIT_CE_000.opt0$ii OPTIM/
 cp -f ecco_cost_MIT_CE_000.opt0$ii OPTIM/
 echo "Line-search: iteration $ii"
 cd OPTIM/
 egrep optimcycle data.optim
 cp -f ../data.optim .
 ./optim.x > std$ii
 cd ..
 echo $i
 i=`expr $i + 1`
 echo "GOT HERE END"
 echo $i
done

exit

for i in $(ls -d runoptiter*00); do 
 mv $i SAVE$i;
done
rm -r runoptiter*
rm OPTIM/OPWARM*



#----------------------------------------------------

# --- end of script ---
