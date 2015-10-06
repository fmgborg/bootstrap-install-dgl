#! /bin/sh

# 2015-10-06 18:39

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

. /usr/local/etc/${CUSTOMIZATION}/shellcolors.inc

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
MOUNT=`${WHICH} mount`
MV=`${WHICH} mv`
NTPDATE=`${WHICH} ntpdate`
RSYNC=`${WHICH} rsync`
SED=`${WHICH} sed`
RM=`${WHICH} rm`
UMOUNT=`${WHICH} umount`
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
