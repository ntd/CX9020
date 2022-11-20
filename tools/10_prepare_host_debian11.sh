#!/bin/sh

DEBIAN_FRONTEND='noninteractive'
sudo apt-get update
sudo apt-get install --no-install-recommends -o Dpkg::Options::="--force-confold" -y \
	autoconf \
	automake \
	bc \
	binfmt-support \
	bison \
	build-essential \
	crossbuild-essential-armhf \
	fdisk \
	flex \
	gcc-arm-none-eabi \
	git \
	kmod \
	libssl-dev \
	libtool \
	mercurial \
	multistrap \
	parted \
	python3-pip \
	qemu-user-static \
	udev \
	wget

sudo pip install \
	wheel
sudo pip install \
	coverage \
	pyfdt

# patch multistrap (https://github.com/volumio/Build/issues/348)
sed -i '/^$config_str .= " -o Apt::Get::AllowUnauthenticated=true"$/i  $config_str .= " -o Acquire::AllowInsecureRepositories=true";' /usr/sbin/multistrap
