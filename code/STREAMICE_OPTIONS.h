C $Header: /u/gcmpack/MITgcm/verification/halfpipe_streamice/code_oad/STREAMICE_OPTIONS.h,v 1.2 2015/02/21 19:56:50 dgoldberg Exp $
C $Name:  $

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

C CPP options file for MYPACKAGE
C
C Use this file for selecting options within package "streamice"

#ifndef STREAMICE_OPTIONS_H
#define STREAMICE_OPTIONS_H
#include "PACKAGES_CONFIG.h"
#ifdef ALLOW_STREAMICE

#include "CPP_OPTIONS.h"

C Place CPP define/undef flag here

#define STREAMICE_CONSTRUCT_MATRIX
#define USE_ALT_RLOW
#define STREAMICE_ALLOW_BGLEN_CONTROL
#define STREAMICE_ALLOW_FRIC_CONTROL
#define ALLOW_STREAMICE_OAD_FP
#define ALLOW_PETSC
#define STREAMICE_GEOM_FILE_SETUP
#define STREAMICE_HYBRID_STRESS
#define STREAMICE_COULOMB_SLIDING
#define STREAMICE_PETSC_3_8
#define ALLOW_STREAMICE_TC_COST
!#define STREAMICE_SMOOTH_FLOATATION


#endif /* ALLOW_MYPACKAGE */
#endif /* MYPACKAGE_OPTIONS_H */

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
