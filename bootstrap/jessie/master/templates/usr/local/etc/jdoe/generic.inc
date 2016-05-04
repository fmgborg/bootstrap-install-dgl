#! /bin/sh

# created:	2015-10-06 18:39
# modified:	2016-03-02
# modified:	2016-03-23 14:51	: aptitude + some foo

# No MAC prefix with Xen

# MAC ADDRESS : encode 'akv' with 14 bits : "a"=00001 "k"=1011 "v"=10110

# Todo : compute MAC address by algorithm

# No MAC prefix with Xen

MAC_PREFIX_CUSTOMIZED_1="0e"	# bit pattern ******10 : "00001110" -> "yyyyyyIO"
MAC_PREFIX_CUSTOMIZED_2="76"	# bit pattern ******** : "01110110"
MAC_PREFIX_CUSTOMIZED_3="0a"	# bit pattern 00001010 : 0x0a ^= 10 private IP 10.*.*.*
MPC1=${MAC_PREFIX_CUSTOMIZED_1}
MPC2=${MAC_PREFIX_CUSTOMIZED_2}
MPC3=${MAC_PREFIX_CUSTOMIZED_3}
MAC_PREFIX_CUSTOMIZED="${MPC1}:${MPC2}:${MPC3}"
MPC=${MAC_PREFIX_CUSTOMIZED}

# No MAC prefix with Xen

LANG=C

# ---->
# This is redundant if generic.inc is invoked correctly.
#
# And this is a bug during dgl bootstrap because /usr/local/etc/customization does not exist yet.
# This was a bad idea.
#
CUSTOMIZATION_PATH_PREFIX="/usr/local"
CUSTOMIZATION_PATH="${CUSTOMIZATION_PATH_PREFIX}/etc/customization"
CUSTOMIZATION_FILE_INC="${CUSTOMIZATION_PATH}/customization.inc"
WORK_FILE=${CUSTOMIZATION_FILE_INC}

# Because it was a bad idea we do not source /usr/local/etc/customization/customization.inc
# If we can find generic.inc we already know the customization.
#. ${WORK_FILE}
# <----

SCI="/usr/local/etc/${CUSTOMIZATION}/shellcolors.inc"
if [ -e ${SCI} ] ; then
	. ${SCI}
fi

PATH="${PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
WHICH=`which which`

APTITUDE=`${WHICH} aptitude`
BASENAME=`${WHICH} basename`
BC=`${WHICH} bc`
BRCTL=`${WHICH} brctl`
CAT=`${WHICH} cat`
CHMOD=`${WHICH} chmod`
CHOWN=`${WHICH} chown`
CP=`${WHICH} cp`
CRYPTSETUP=`${WHICH} cryptsetup`
CUT=`${WHICH} cut`
DATE=`${WHICH} date`
ECHO=`${WHICH} echo`
FIND=`${WHICH} find`
GIT=`${WHICH} git`
IFCONFIG=`${WHICH} ifconfig`
IP=`${WHICH} ip`
IPTABLES=`${WHICH} iptables`
LESS=`${WHICH} less`
LVCREATE=`${WHICH} lvcreate`
MKDIR=`${WHICH} mkdir`
MKFS_EXT3=`${WHICH} mkfs.ext3`
MKSWAP=`${WHICH} mkswap`
MOUNT=`${WHICH} mount`
MV=`${WHICH} mv`
NTPDATE=`${WHICH} ntpdate`
RSYNC=`${WHICH} rsync`
SED=`${WHICH} sed`
SWAPOFF=`${WHICH} swapoff`
SWAPON=`${WHICH} swapon`
RM=`${WHICH} rm`
UMOUNT=`${WHICH} umount`
VGCHANGE=`${WHICH} vgchange`
VIM=`${WHICH} vim`
WC=`${WHICH} wc`

LOGPATH="/var/log/${CUSTOMIZATION}"
LOGFILE="${CUSTOMIZATION}-generic.log"
LOGGING="${LOGPATH}/${LOGFILE}"

if [ ! -d ${LOGPATH} ] ; then
        ${MKDIR} -p ${LOGPATH}
fi

MAC_PREFIX_KVM="52:54:00"
MAX_PREFIX_XEN="00:16:3e"

# EOF
