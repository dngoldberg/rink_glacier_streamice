
# Switch compilers as  the Cray compiler gives an error.
#module swap PrgEnv-gnu PrgEnv-intel
#module swap PrgEnv-cray PrgEnv-intel
##module swap cray-netcdf netcdf
#module load netcdf-nc-max-vars
#module load cray-petsc


#module restore PrgEnv-cray
#module load cray-hdf5-parallel/1.12.0.2
#module load cray-netcdf-hdf5parallel/4.7.4.2


source ~/.bashrc
module purge
module load intel/19.1.1 impi/19.0.9 netcdf/4.6.2 
module load petsc/3.15-uni
module load tacc-singularity

#ROOTDIR=/home/dgoldber/MITgcm
export LD_LIBRARY_PATH=/work/n02/n02/dngoldbe/petsc/lib:$CRAY_LD_LIBRARY_PATH:$LD_LIBRARY_PATH
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
$ROOTDIR/tools/genmake2 -mods='../code' -of=$OLDPWD/linux_amd64_ifort+mpi_lonestar6  -oad -mpi --oadsingularity "$sing_str"

#$ROOTDIR/tools/genmake2 -ieee -mods='../code ../newcode' -of=$ROOTDIR/tools/build_options/linux_amd64_gfortran -mpi
#$ROOTDIR/tools/genmake2 -mods='../code' -mpi
cp $PETSC_DIR/milan-uni/include/*.mod ./
echo $LD_LIBRARY_PATH
make adAll

# Switch Programming Environment back
#module swap PrgEnv-intel PrgEnv-cray
#module swap netcdf cray-netcdf
