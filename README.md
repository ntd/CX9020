# CX9020

Unofficial fork for building the image using docker.

This repository provides Scripts and Patches to build a basic Linux (Debian) System for a [Beckhoff CX9020 Controller](https://www.beckhoff.com/default.asp?embedded_pc/cx9020.htm).
It only works with devices which are ordered with a special ordering number (CX9020-0100) which ensures that the device boots directly from the microSD card instead of using the internal bootloader.
Please make sure to follow the steps below to create your microSD card.

## Installation
```
# Get the repository
#====================
git clone -b docker-support https://github.com/ntd/CX9020.git
cd CX9020

# Create the building OS image
#=============================
docker build -t cx9020 .

# Start the building OS container
#================================
docker run --privileged --mount type=bind,src=$(pwd),dst=/root/CX9020 --mount type=bind,src=/dev,dst=/devhost -itw /root/CX9020/ cx9020 /bin/bash

# NOW YOU ARE INSIDE THE BUILDING OS CONTAINER
# Note: all files generated here are owned by root in the host OS

# Optimize `git clone` downloading only the last commit
#======================================================
export GIT_CLONE_ARGS='--depth 1'

# Build u-boot
#=============
tools/prepare_uboot.sh v2019.10
make uboot

# Build the kernel
#=================
tools/prepare_kernel.sh v5.10-rt
make kernel

# Build the etherlab master stack (optional)
#===========================================
tools/prepare_etherlab.sh stable-1.5
make etherlab

# Integrate acontis kernel extension atemsys from EC-Master SDK for emllCCAT support (optional)
#==============================================================================================
tools/prepare_acontis.sh
make acontis

# Prepare the SD card
# WARNING: use the correct device name instead of `<SDCARD>` (e.g. `/devhost/sdc`)
#=================================================================================
scripts/install.sh /devhost/<SDCARD> /tmp/rootfs
```

### Working around broken EDID panels

If you get a flashing or completely blank panel, double check it has no broken EDID support. Check [this issue](https://github.com/Beckhoff/CX9020/issues/19) for an example of the nightmare you are going to encounter.

## Usage

The standard login on first boot:

User:     root
Password: root

Please change the root password immediately and additionally create your own user.

You can also access with SSH by using the following user:

User:     cx9020
Password: cx9020

### acontis EC-Master example (optional)

To run the EcMasterDemo, extract the EC-Master SDK in /opt/EC-Master and start it from /opt/EC-Master/Bin/Linux/armv6-vfp-eabihf using:
```
EcMasterDemo -ccat 1 1
```
See manuals in the SDK's "Doc" folder for how to build and run EC-Master applications

## History

**TODO:** Write history
