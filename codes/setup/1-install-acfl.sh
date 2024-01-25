#!/bin/bash

# download acfl for ubuntu 20.04 from arm website - https://developer.arm.com/downloads/-/arm-compiler-for-linux
# please check the download link for the appropriate version
# install acfl will include armpl automatically

mkdir -p /shared/tools && cd /shared/tools
wget -O arm-compiler-for-linux_23.04.1+AmazonLinux-2_aarch64.tar 'https://developer.arm.com/-/media/Files/downloads/hpc/arm-compiler-for-linux/23-04-1/arm-compiler-for-linux_23.04.1_AmazonLinux-2_aarch64.tar?rev=0c3a43ffe3054bb69a139e21401f22b1&revision=0c3a43ff-e305-4bb6-9a13-9e21401f22b1'
tar xvf arm-compiler-for-linux_23.04.1+AmazonLinux-2_aarch64.tar
sudo ./arm-compiler-for-linux_23.04.1_AmazonLinux-2/arm-compiler-for-linux_23.04.1_AmazonLinux-2.sh -i /shared/arm -a --force
