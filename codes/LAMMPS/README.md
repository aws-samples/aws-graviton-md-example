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

This assumes both the ARM compiler and OpenMPI have already been installed.

Run [2a-compile-lammps-acfl-sve.sh](https://github.com/aws-samples/aws-graviton-md-example/blob/main/codes/LAMMPS/2a-compile-lammps-acfl-sve.sh).

To edit the compile flags, change the following line of the compile script:

```bash
sed -i 's/CCFLAGS =.*/CCFLAGS = -march=armv8-a+sve -Rpass=loop-vectorize/g' ./Makefile.${target}
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

The following command builds the LAMMPS executable

```bash
make -j $(nproc) ${target}
```

### 1.3 LAMMPS Submit Script Example

A LAMMPS submit script example is provided in [3-lammps-acfl-sve.sh](https://github.com/aws-samples/aws-graviton-md-example/blob/main/codes/LAMMPS/3-lammps-acfl-sve.sh)

Notes:

- to change the number of nodes, update the number of nodes in the line `#SBATCH --nodes=4` and the number of cores in the line `N="256"`, where N is the number of nodes multiplied by the cores per node (64 in the case of `hpc7g.16xlarge`).
- to change the input file to another benchmark, replace `in.lj` (Lennard Jones atomic fluid) with `in.chain.scaled` (bead-spring polymer), `in.eam` (metal solid), `in.chute.scaled` (granular chute flow), or `in.rhodo.scaled` (rhodopsin protein).
