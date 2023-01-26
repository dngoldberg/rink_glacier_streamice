

source ~/.bashrc
module purge
module load intel/19.1.1 impi/19.0.9 netcdf/4.6.2 
module load tacc-singularity

build_dir=build
code_dir=code

if [ -d "../$build_dir" ]; then
  cd ../$build_dir
  rm -rf *
else
  echo 'Creating build directory'
  mkdir ../$build_dir
  cd ../$build_dir
fi

# THIS NEEDS TO POINT TO THE  SINGULARITY OAD IMAGE
sing_str="/work/09208/dgoldber/ls6/openad/openad.sif"

rm ../$code_dir/cost_test.F
ln ../$code_dir/cost_test.F.snap_noBglen ../$code_dir/cost_test.F


make CLEAN
$ROOTDIR/tools/genmake2 -mods='../code' -of=$OLDPWD/linux_amd64_ifort+mpi_lonestar6_ownpetsc  -oad -mpi --oadsingularity "$sing_str"

#$ROOTDIR/tools/genmake2 -ieee -mods='../code ../newcode' -of=$ROOTDIR/tools/build_options/linux_amd64_gfortran -mpi
#$ROOTDIR/tools/genmake2 -mods='../code' -mpi

# will need to adapt this path to yours
cp $OWN_PETSC_DIR/arch-linux-c-opt/include/*.mod ./
make adAll

# Switch Programming Environment back
#module swap PrgEnv-intel PrgEnv-cray
#module swap netcdf cray-netcdf
