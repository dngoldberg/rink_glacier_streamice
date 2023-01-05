#!/bin/bash
################################################
# Clean out old results and link input files.
################################################

run_folder="run_ad"
input_dir=../input/
build_dir="build"

# Empty the run directory - but first make sure it exists!
if [ -d "../$run_folder" ]; then
  cd ../$run_folder
  rm -rf *
else
  mkdir ../$run_folder
  cd ../$run_folder
fi


ln -s $input_dir/* .
ln -s ../lonestar_scripts/opt_script.csh .
ln -s ../lonestar_scripts/add0upto3c .
ln -s ../lonestar_scripts/clear_optim.sh .

# Deep copy of the master namelist (so it doesn't get overwritten in input/)
rm -f data
cp -f $input_dir/data .

rm -f data.streamice
cp -f $input_dir/data.streamice ./

#if [ $2 == 'weert' ]; then
# str=" streamice_allow_reg_coulomb=.false."
#else
str=" streamice_allow_reg_coulomb=.true."
#fi

sed "s/.*reg_coulomb.*/$str/" data.streamice > data.streamice.temp
mv data.streamice.temp data.streamice



# Link executables
ln -s ../$build_dir/mitgcmuv_ad .



module purge
module load intel/19.1.1 impi/19.0.9 netcdf/4.6.2



optimdir=OPTIM
builddir="../../optim_m1qn3/src"

if [ ! -d "$optimdir" ]; then
 mkdir -p $optimdir
fi

echo "GOT HERE PREPARE"

cd OPTIM
rm optim.x
rm data.optim
rm data.ctrl
echo $PWD
echo $builddir
cd $builddir
cp ../../lonestar_scripts/Makefile ./
str="                  -I../../$build_dir"
sed "s@.*-I../../build_ad.*@$str@" Makefile > makefile_temp;
mv makefile_temp Makefile
make clean; make depend; make; 
cd $OLDPWD
cp $builddir/optim.x .
ln -s ../data.optim .
ln -s ../data.ctrl .
cd ..
./clear_optim.sh


