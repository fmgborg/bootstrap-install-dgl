#! /bin/sh

# 2015-10-04 23:44	# Debian bootstrap installation

LANG=C

. ${BASE_PATH}/meta/sbin/shellcolors.inc

PATH="${PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
WHICH=`which which`

BASENAME=`${WHICH} basename`
BC=`${WHICH} bc`
BRCTL=`${WHICH} brctl`
CAT=`${WHICH} cat`
CP=`${WHICH} cp`
CUT=`${WHICH} cut`
DATE=`${WHICH} date`
ECHO=`${WHICH} echo`
FIND=`${WHICH} find`
IFCONFIG=`${WHICH} ifconfig`
IPTABLES=`${WHICH} iptables`
LESS=`${WHICH} less`
LVCREATE=`${WHICH} lvcreate`
MKDIR=`${WHICH} mkdir`
MKFS_EXT3=`${WHICH} mkfs.ext3`
MKSWAP=`${WHICH} mkswap`
MV=`${WHICH} mv`
MOUNT=`${WHICH} mount`
NTPDATE=`${WHICH} ntpdate`
RM=`${WHICH} rm`
RSYNC=`${WHICH} rsync`
SED=`${WHICH} sed`
UMOUNT=`${WHICH} umount`
VIM=`${WHICH} vim`
WC=`${WHICH} wc`

# EOF
