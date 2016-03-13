#!/bin/bash

if [ -d /ccache ]; then
    export USE_CCACHE=1
    export CCACHE_COMPRESS=1
    export CCACHE_DIR=/ccache
fi
if [ -d /home/build/.ccache ]; then
    export USE_CCACHE=1
    export CCACHE_COMPRESS=1
    export CCACHE_DIR=/home/build/.ccache
fi
 
export ROM_BUILDTYPE=NIGHTLY 
export BUILD_WITH_COLORS=0

DEVICE=$device

if [ -n $DEVICE ]; then
    echo DEVICE not set
    exit 1
fi

echo USER=$USER
echo DEVICE=$DEVICE
echo CCACHE_DIR=$CCACHE_DIR

cd /home/build/omni

#repo sync -j48
#fixme: uncommitted changes suddenly appear
cd .repo/manifests
git reset --hard
cd ../..
cd .repo/repo
git reset --hard
cd ../..
repo forall -c "git reset --hard" -j48
repo sync --force-sync -j48
rm -rf out

#use non-public keys to sign ROMs - keys not in git for obvious reasons
cp /home/build/.keys/* ./build/target/product/security

. build/envsetup.sh
brunch $DEVICE

if [ $? -eq 0 ]; then
	source upload_nightly.sh
	/home/build/delta/omnidelta.sh $DEVICE
else
	exit 1
fi
