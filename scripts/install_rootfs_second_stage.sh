#!/bin/bash
# run this inside of your chroot'ed new rootfs

export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
export LC_ALL=C LANGUAGE=C LANG=C

dpkg --configure -a

set -e

cp -a /usr/share/zoneinfo/Europe/Berlin /etc/localtime
echo 'CX9020' > /etc/hostname

mount proc -t proc /proc
dpkg --configure -a
umount /proc

# Create `cx9020` user, so you can SSH into this box with it
useradd -ms /bin/bash cx9020

echo 'root:root' | chpasswd
echo 'cx9020:cx9020' | chpasswd
