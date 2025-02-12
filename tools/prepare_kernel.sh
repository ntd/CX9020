#!/bin/bash
# RT patches are hosted here: https://www.kernel.org/pub/linux/kernel/projects/rt/
# Overview of maintained kernels: https://kernel.org/releases.html

set -e

if [ "$#" -ne 1 ]; then

        echo -e "Usage:\n $0 <KERNEL_VERSION>\n\nexample:\n $0 v4.20"
        exit 64
fi

RT_VERSION=${1}
REPO=kernel
GIT_REMOTE=https://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git
#GIT_REMOTE=https://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-rt-devel.git
#GIT_REMOTE=https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

ccat_remote="${ccat_remote:-https://github.com/Beckhoff/CCAT}"
ccat_branch="${ccat_branch:-master}"

git clone -b ${RT_VERSION} ${GIT_REMOTE} ${REPO} ${GIT_CLONE_ARGS} ${KERNEL_CLONE_ARGS}
pushd ${REPO}
git checkout -b dev-${RT_VERSION}

# Apply custom patches, if any
shopt -s nullglob
for f in ../kernel-patches/000*; do
	echo "Applying '$f'"
	patch -tNp1 -i "$f"
done

# Prepared kernel configuration
cp -a ../kernel-patches/config-CX9020 .config

# Clone ccat driver repository
popd
git clone -b ${ccat_branch} ${ccat_remote} ccat
