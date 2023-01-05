#!/bin/csh

rm -r runopt* outputopt* OPTIM/OPWARM* OPTIM/ecco_c* OPTIM/m1qn3_output.txt OPTIM/std* *.data *.meta ecco_c* run*.tar oad_cp.* STDOUT* STDERR* diagnostics_*txt -v
rm -rv diag_pack*bin diag_unpack*bin
set ite=`egrep 'optimcycle' data.optim | sed 's/ optimcycle=//'| sed 's/,$//'`
sed "s/ optimcycle=$ite/ optimcycle=-1/" data.optim > TTT.tmp
mv -f TTT.tmp data.optim

