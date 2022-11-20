#!/bin/bash

set -e

if [ $# -ne 1 ]; then
	echo -e "Usage:\n $0 <u-boot version>\n\nexample:\n $0 v2018.11"
	exit 64
fi

VERSION=$1

git clone -b ${VERSION} http://git.denx.de/u-boot.git ${GIT_CLONE_ARGS} ${UBOOT_CLONE_ARGS}
pushd u-boot/
git checkout -b dev-${VERSION}

# Apply custom patches, if any
shopt -s nullglob
for f in ../u-boot-patches/000*; do
	echo "Applying '$f'"
	patch -tNp1 -i "$f"
done
