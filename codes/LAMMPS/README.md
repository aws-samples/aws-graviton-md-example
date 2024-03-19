# README

## 1. LAMMPS Setup

### 1.1 Download LAMMPS

Run [1-download-lammps.sh](https://github.com/aws-samples/aws-graviton-md-example/blob/main/codes/LAMMPS/1-download-lammps.sh) and switch to the specific branch of interest, such as `stable_23Jun2022_update4`:

```bash
INSTALLDIR=~/software
cd $INSTALLDIR
git clone https://github.com/lammps/lammps.git
cd lammps
git checkout stable_23Jun2022_update4
```

### 1.2 Compile LAMMPS

To edit the compile flags, change the following line of the compile script:

```bash
sed -i 's/CCFLAGS =.*/CCFLAGS = -O3 -march=armv8-a+sve -fopenmp/g' ./Makefile.${target}  # if compiling LAMMPS with ARM
sed -i 's/CCFLAGS =.*/CCFLAGS = -O3 -march=native -mcpu=native -fopenmp -std=c++11/g' ./Makefile.${target}  # if compiling LAMMPS with GCC
```

To add additional [LAMMPS packages](https://docs.lammps.org/Packages_list.html), add `make yes-<package_name>` after the `make-yes-most` line in the following section of the compile script. The following example shows how the `molecule`, `kspace`, `rigid`, `asphere`, `opt`, and `openmp` packages can be added:

```bash
cd ${INSTALLDIR}/lammps/src
make clean-all
make no-all
make yes-most
make yes-molecule
make yes-kspace
make yes-rigid
make yes-asphere
make yes-opt
make yes-openmp
```

To compile LAMMPS (this assumes both the compiler and OpenMPI have already been installed)

- **ARM compiler**: run [2a-compile-lammps-acfl-sve.sh](https://github.com/aws-samples/aws-graviton-md-example/blob/main/codes/LAMMPS/2a-compile-lammps-acfl-sve.sh) 
- **GCC compiler**: run [2b-compile-lammps-gcc.sh](https://github.com/aws-samples/aws-graviton-md-example/blob/main/codes/LAMMPS/2b-compile-lammps-gcc.sh)

The following command in the script above builds the LAMMPS executable

```bash
make -j $(nproc) ${target}
```

### 1.3 LAMMPS Submit Script Example

LAMMPS submit script examples are provided:

- **ARM-compiled LAMMPS**: [3a-lammps-acfl-sve.sh](https://github.com/aws-samples/aws-graviton-md-example/blob/main/codes/LAMMPS/3a-lammps-acfl-sve.sh)
- **GCC-compiled LAMMPS**: [3b-lammps-gcc.sh](https://github.com/aws-samples/aws-graviton-md-example/blob/main/codes/LAMMPS/3b-lammps-gcc.sh)

Notes:

- to change the number of nodes, update the number of nodes in the line `#SBATCH --nodes=4`
- to change the number of OpenMP threads, update the line `export OMP_NUM_THREADS=2`, where 2 is the number of OpenMP threads
- to change the number of MPI processes, update the flag `-np 128`, where 128 is the number of MPI processes (OpenMP threads x number of MPI processes should be equal to the number of physical cores)
- to change the number of MPI processes per node, update the flag `--map-by ppr:32:node`, where 32 indicates 32 MPI processes per node (OpenMP threads x number of MPI processes per node should be equal to 64. 64 is the number of physical cores per node on the hpc7g.16xlarge)
- to change the input file to another benchmark, replace `in.lj` (Lennard Jones atomic fluid) with `in.chain.scaled` (bead-spring polymer), `in.eam` (metal solid), `in.chute.scaled` (granular chute flow), or `in.rhodo.scaled` (rhodopsin protein).
