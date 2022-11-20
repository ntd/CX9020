#!/bin/bash

set -e
set -o nounset

if [ $# -ne 1 ] || ! [ -d $1 ]; then
	echo -e "Usage:\n $0 <rootfs_mount>\n\nexample:\n $0 /tmp/rootfs\n\n"
	exit -1
fi

ROOTFS_MOUNT=$1
ETHERLAB=ethercat

if [ -d "${ETHERLAB}" ]; then
	pushd "${ETHERLAB}"
	make INSTALL_MOD_PATH=${ROOTFS_MOUNT} modules_install
	make DESTDIR=${ROOTFS_MOUNT} install
	popd

	sed -b -i 's/MASTER0_DEVICE=\"\"/MASTER0_DEVICE=\"ff:ff:ff:ff:ff:ff\"/' ${ROOTFS_MOUNT}/etc/ethercat.conf
	sed -b -i 's/DEVICE_MODULES=\"\"/DEVICE_MODULES=\"ccat\"/' ${ROOTFS_MOUNT}/etc/ethercat.conf
	printf "ccat_netdev\n" > ${ROOTFS_MOUNT}/etc/modules-load.d/ccat.conf
	sudo chroot ${ROOTFS_MOUNT} /bin/bash -c "systemctl enable ethercat"
	cp -a tests/etherlab/example.bin ${ROOTFS_MOUNT}/root/
fi
