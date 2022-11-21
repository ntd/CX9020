#!/bin/bash

set -e

if [ $# -ne 1 ]; then
	echo -e "Usage:\n $0 <branch>\n\nexample:\n $0 stable-1.5"
	exit 64
fi

BRANCH=$1

git clone -b ${BRANCH} https://gitlab.com/etherlab.org/ethercat.git ${GIT_CLONE_ARGS} ${ETHERLAB_CLONE_ARGS}
pushd ethercat/
git checkout -b dev-${BRANCH}

# Apply custom patches, if any
shopt -s nullglob
for f in ../ethercat-patches/000*; do
	echo "Applying '$f'"
	patch -tNp1 -i "$f"
done

./bootstrap
