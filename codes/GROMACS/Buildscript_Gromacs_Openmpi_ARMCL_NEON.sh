##
# Purpose: To build gromacs binary using ARM compiler for Linux and ARM performance library
# Software toolchain: OpenMPI 4.1.5 and ARM compiler for Linux and ARM performance library 23.04
# July, 2023 
# JEN-CHANG CHEN; jamchn@amazon.com
# Prerequisite
# ARM compiler for Linux and perfromance library 23.04 has been installed and loaded
# OpenMPI 4.1.5 has been setup into your bash environment
# Gromacs 2022.5 has been downloaded and unpack into "/home/ec2-user/software/" 
# CMAKE version 3.13 or later has been installed properly

## Enter to the software folder
cd /home/ec2-user/software/gromacs-2022.5
## Create a build folder for neon
mkdir build_neon
cd build_neon 

## Gromacs for ARM compiler (assuming you installed ACfL on /shared/arm)
module use /shared/arm/modulefiles
module load libfabric-aws
module load acfl
module load armpl

export LDFLAGS='-larmpl -lm'
cmake \
        -DCMAKE_INSTALL_PREFIX=/shared/gromacs2022.5-armcl-armcom \
        -DBUILD_SHARED_LIBS=off \
        -DBUILD_TESTING=off \
        -DREGRESSIONTEST_DOWNLOAD=OFF \
        -DCMAKE_C_COMPILER=mpicc \
        -DCMAKE_CXX_COMPILER=mpicxx \
        -DGMX_SIMD=ARM_NEON_ASIMD \
        -DGMX_DOUBLE=off \
        -DGMX_FFT_LIBRARY=fftw3 \
        -DGMX_BLAS_USER=${ARMPL_LIBRARIES}/libarmpl.so \
        -DGMX_LAPACK_USER=${ARMPL_LIBRARIES}/libarmpl.so \
        -DFFTWF_LIBRARY=${ARMPL_LIBRARIES}/libarmpl.so \
        -DFFTWF_INCLUDE_DIR=${ARMPL_INCLUDES} \
        -DGMX_GPU=off \
        -DGMX_MPI=on \
        -DGMX_OPENMP=off \
        -DGMX_X11=off \
         ..
## assume c7g.4xl
make -j 16
make install
