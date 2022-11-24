cd ../run
rm -rf *

#
# namelists (always copy 'data' so not overwritten in restarts)
# 

ln -s ../input/* . 
rm -f data
cp -f ../input/data .

#
# code and utilities
#

ln -s ../build/mitgcmuv .
ln -s ../../../utilities/mit2nc/mit2nc .
ln -s ../../../utilities/set_niter.tcl

