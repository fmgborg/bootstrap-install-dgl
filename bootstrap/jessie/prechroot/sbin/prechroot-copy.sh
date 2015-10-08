#!/bin/bash

# 2015-10-08

# quick 'n dirty

# safety lock
RUN="n"
#RUN="y"

CHROOT_TARGET="/mnt"
PRE_BOOTSTRAP="opt"
REL_SOURCE="bootstrap/jessie/master/generic"
FULL_SOURCE_PATH="${CHROOT_TARGET}/${PRE_BOOTSTRAP}/${REL_SOURCE}"
FSP="${FULL_SOURCE_PATH}"
FULL_TARGET_PATH="${CHROOT_TARGET}"
FTP="${FULL_TARGET_PATH}"

rsync_file() {
echo rsync -au ${FSP}${LF} ${FTP}${LF}
rsync -au ${FSP}${LF} ${FTP}${LF}
}

copy_files() {
LOCAL_FILE="/root/.bashrc"
LF=${LOCAL_FILE}
mv ${FTP}${LF} ${FTP}${LF}.orig
echo mv ${FTP}${LF} ${FTP}${LF}.orig
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

echo source : $FSP
echo target : $FTP

if [ "${RUN}" = "y" ] ; then
	copy_files
else
	echo 'missing permission : actual value RUN="'${RUN}'" should be RUN="y" instead'
fi

# EOF
