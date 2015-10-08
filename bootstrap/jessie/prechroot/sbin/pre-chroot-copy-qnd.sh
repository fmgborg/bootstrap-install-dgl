#!/bin/bash

# 2015-10-08

# quick 'n dirty

CHROOT_TARGET="/mnt"
PRE_BOOTSTRAP="opt"
REL_SOURCE="bootstrap/jessie/master/generic"
FULL_SOURCE_PATH="${CHROOT_TARGET}/${PRE_BOOTSTRAP}/${REL_SOURCE}"
FSP="${FULL_SOURCE_PATH}"
FULL_TARGET_PATH="${CHROOT_TARGET}"
FTP="${FULL_TARGET_PATH}"

echo s : $FSP
echo t : $FTP

LOCAL_FILE="/root/.bashrc"
LF=${LOCAL_FILE}
#mv ${FTP}${LF} ${FTP}${LF}.orig
echo mv ${FTP}${LF} ${FTP}${LF}.orig
#rsync -au ${FSP}${LF} ${FTP}${LF}
echo rsync -au ${FSP}${LF} ${FTP}${LF}

LOCAL_FILE="/root/.bash_history"
LF=${LOCAL_FILE}
#rsync -au ${FSP}${LF} ${FTP}${LF}
echo rsync -au ${FSP}${LF} ${FTP}${LF}

LOCAL_FILE="/root/.vim"
LF=${LOCAL_FILE}
#rsync -au ${FSP}${LF} ${FTP}${LF}
echo rsync -au ${FSP}${LF} ${FTP}${LF}

LOCAL_FILE="/root/.vimrc"
LF=${LOCAL_FILE}
#rsync -au ${FSP}${LF} ${FTP}${LF}
echo rsync -au ${FSP}${LF} ${FTP}${LF}

# EOF
