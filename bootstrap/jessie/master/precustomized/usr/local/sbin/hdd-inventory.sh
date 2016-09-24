#!/bin/bash

# author                                : fmg
# doc   (date of creation)              : 2016-09-24 21:56
# dolm  (date of last modification)     : 2016-09-24 22:58

SDX="sdc"
DEVICE="/dev/${SDX}"

NOW=`date +%Y%m%d-%H%M`
SUBDIR="metadata-${NOW}"

mkdir -p ${SUBDIR}
cd ${SUBDIR}

# MBR
dd if=${DEVICE} of=mbr.bin bs=512 count=1

fdisk -l ${DEVICE}				> fdisk-l.txt
fdisk.distrib -l ${DEVICE}			> fdisk.distrib-l.txt
gdisk -l ${DEVICE}				> gdisk-l.txt
parted ${DEVICE} print				> parted-print.txt

# disk free
mount -o ro ${DEVICE}1 /mnt
#
LANG=de_DE.UTF-8 df -h | grep -E "(^Da|${SDX})"	> df-h.de.txt
LANG=de_DE.UTF-8 df -m | grep -E "(^Da|${SDX})"	> df-m.de.txt
LANG=de_DE.UTF-8 df | grep -E "(^Da|${SDX})"	> df.de.txt
#
LANG=C df -h | grep -E "(^F|${SDX})"		> df-h.en.txt
LANG=C df -m | grep -E "(^F|${SDX})"		> df-m.en.txt
LANG=C df | grep -E "(^F|${SDX})"		> df.en.txt
#
###umount /mnt
# mount
###mount -o ro ${DEVICE}1 /mnt
mount | grep ${SDX}				> mount-ro.txt
D_SUBDIR="data-ro-${NOW}"
mkdir -p "../${D_SUBDIR}"
rsync -a /mnt/ "../${D_SUBDIR}"
umount /mnt
#
mount ${DEVICE}1 /mnt
mount | grep ${SDX}				> mount.txt
umount /mnt

# EOF
