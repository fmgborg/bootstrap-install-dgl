#!/bin/bash

# 2015-10-08

# safety lock
RUN="n"
#RUN="y"

ARCH="amd64"
FLAVOR="jessie"
TARGET="/mnt"
MIRROR="http://ftp.debian.org/debian"
OPTIONS="--arch ${ARCH} ${FLAVOR} ${TARGET} ${MIRROR}"

bootstrap() {
date
time debootstrap ${OPTIONS}
date
}

copy_files() {
echo /root/.bash_history
echo /root/.bashrc
echo '/root/.vim*'
}

#bootstrap
copy_files


# EOF
