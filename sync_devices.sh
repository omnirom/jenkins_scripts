#!/bin/sh

cd /home/build
if [ -e jenkins ]; then
    rm -fr jenkins
fi

git clone https://github.com/omnirom/jenkins -b android-6.0
exit 0
