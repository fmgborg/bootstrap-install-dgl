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

CHROOT_TARGET="/mnt"
PRE_BOOTSTRAP="opt"
REL_SOURCE="bootstrap/jessie/master/generic"
FULL_SOURCE_PATH="${CHROOT_TARGET}/${PRE_BOOTSTRAP}/${REL_SOURCE}"
FSP="${FULL_SOURCE_PATH}"
FULL_TARGET_PATH="${CHROOT_TARGET}"
FTP="${FULL_TARGET_PATH}"

MYSELF="bootstrap"
COPY_SOFTWARE_SOURCE="/opt/${MYSELF}"
CSS="${COPY_SOFTWARE_SOURCE}"
COPY_SOFTWARE_TARGET="${CHROOT_TARGET}/${PRE_BOOTSTRAP}/${MYSELF}"
CST="${COPY_SOFTWARE_TARGET}"

bootstrap() {
date
echo debootstrap ${OPTIONS}
time debootstrap ${OPTIONS}
date
}

copy_bootstrap() {
echo rsync -au --exclude '*system*' --exclude '*garbage*' ${CSS}/ ${CST}/
rsync -au --exclude '*system*' --exclude '*garbage*' ${CSS}/ ${CST}/
}

rsync_file() {
echo rsync -au ${FSP}${LF} ${FTP}${LF}
rsync -au ${FSP}${LF} ${FTP}${LF}
}

copy_files() {
LOCAL_FILE="/root/.bashrc"
LF=${LOCAL_FILE}
echo mv ${FTP}${LF} ${FTP}${LF}.orig
mv ${FTP}${LF} ${FTP}${LF}.orig
rsync_file

LOCAL_FILE="/root/.bash_history"
LF=${LOCAL_FILE}
rsync_file

LOCAL_FILE="/root/.vim"
LF=${LOCAL_FILE}
rsync_file

LOCAL_FILE="/root/.vimrc"
LF=${LOCAL_FILE}
rsync_file
}

if [ "${RUN}" = "y" ] ; then
	echo "RUN=${RUN}"
	bootstrap
	copy_files
else
	echo 'missing permission : actual value RUN="'${RUN}'" should be RUN="y" instead'
fi

# EOF
