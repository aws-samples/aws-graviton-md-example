##
#!/bin/bash

# Load the path to the latest cmake you installed eariler 
export PATH=/shared/tools/cmake-3.26.4-arm64/bin:$PATH

# Create a build directory
cd ~/software/gromacs-2022.5
mkdir build_sve && cd build_sve

# Install Gromacs with Arm compilers and OpenMPI 4.1.5 

export PATH=/shared/tools/openmpi-4.1.5-arml/bin:$PATH
export LD_LIBRARY_PATH=/shared/tools/openmpi-4.1.5-arml/lib:$LD_LIBRARY_PATH

module use /shared/arm/modulefiles
module load acfl/23.04.1
module load armpl/23.04.1
module load libfabric-aws/1.17.1

export LDFLAGS='-larmpl -lm'
cmake .. -DGMX_BUILD_OWN_FFTW=OFF \
        -DCMAKE_INSTALL_PREFIX=/shared/gromacs2022.5-armcl-sve \
        -DBUILD_SHARED_LIBS=off \
        -DBUILD_TESTING=off \
        -DREGRESSIONTEST_DOWNLOAD=OFF \
        -DCMAKE_C_COMPILER=mpicc \
        -DCMAKE_CXX_COMPILER=mpicxx \
        -DGMX_SIMD=ARM_SVE \
        -DGMX_DOUBLE=off \
        -DGMX_FFT_LIBRARY=fftw3 \
        -DGMX_BLAS_USER=${ARMPL_LIBRARIES}/libarmpl.so \
        -DGMX_LAPACK_USER=${ARMPL_LIBRARIES}/libarmpl.so \
        -DFFTWF_LIBRARY=${ARMPL_LIBRARIES}/libarmpl.so \
        -DFFTWF_INCLUDE_DIR=${ARMPL_INCLUDES} \
        -DGMX_GPU=off \
        -DGMX_MPI=on \
        -DGMX_OPENMP=off \
        -DGMX_X11=off

make
make install

