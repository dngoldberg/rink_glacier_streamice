# rink_glacier_streamice
A set of input files, shell scripts of code to manage the simulation of a section of western greenland with MITgcm/STREAMICE

**The Repository is organised as follows:**
- **code** folder: A set of files that are needed in order to compile MITgcm in order to use the STREAMICE package.
- **input** folder: A set of text input files to be read by MITgcm at runtime, as well as matlab files which are used to create binary inputs
- **archer_scripts** folder: A set of files helpful for use on the ARCHER2 supercomputer (*Not intended for use at UT*)
- **ls6_scripts** folder: A set of files provided by An Nguyen to enable use on the Lonestar6 supercomputer (*in progress*)

**Note: this readme is a placeholder for a more extensive wiki that will evolve over time. The bare minimum is given below.**

## Overview of experiment.

This experiment models a section of West Greenland containing Rink, Inngia and Umiammakku Isbrae using the STREAMICE package of MITgcm. A resolution of 600m in a polar stereographic reference grid is used. The geometry of the model (surface elevation and bed elevation) are interpolated from BedMachine Greenland, with "islands" of ice removed. A hybrid stress balance (Goldberg, 2010) is used, with a coulomb-limited velocity-dependent sliding law (Cornford et al, 2020). The ITS_LIVE velocity mosaic is used as a constraint in a control method inversion. The control parameters are $\beta$, the square root of the sliding coefficient, and $\overline{B}$, the vertically averaged ice-sheet stiffness parameter (equivalent to $A^{-1/3}$ where $A$ is Glen's coefficient). An uniform initial guess is used for each; there is no constraint for $\overline{B}$ to match, or be informed by, ice-sheet temperature. Below the results of this inversion are shown: the modelled, observed speed and the difference.

![Modelled speed](https://www.geos.ed.ac.uk/~dgoldber/rink_figs/modelled_rink.png)
![Observed speed](https://www.geos.ed.ac.uk/~dgoldber/rink_figs/itslive_rink.png)
![Difference](https://www.geos.ed.ac.uk/~dgoldber/rink_figs/itslive_model_diff_rink.png)

## Steps in running experiment.

### Preparing input files.

The input folder contains 3 matlab files:
- `snip.m` defines the domain and the grid locations, and subsets the ITS_LIVE and BM-Greenland files for easier use later on.
- `gen_mesh.m` defines the number of cpus (`npx` and `npy`), determines the size of the computational domain (i.e. by "padding" noncomputational cells to ensure the appropriate tile size)


Goldberg, D N (2011). A variationally-derived, depth-integrated approximation to the Blatter/Pattyn balance. J. of Glaciology, 57, 157-170.

Cornford, S and others (2020). Results of the third Marine Ice Sheet Model Intercomparison Project (MISMIP+). The Cryosphere, 14, 2283–2301. (doi:10.5194/tc-2019-326)
