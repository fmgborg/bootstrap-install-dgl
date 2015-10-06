#!/bin/sh

TODO=$1

MOUNTPOINT="/mnt"

off() {
umount ${MOUNTPOINT}/sys
umount ${MOUNTPOINT}/proc
umount ${MOUNTPOINT}/dev/pts
umount ${MOUNTPOINT}/dev
}

on() {
mount -o bind /dev "${MOUNTPOINT}/dev"
mount -o bind /dev/pts "${MOUNTPOINT}/dev/pts"
mount -o bind /proc "${MOUNTPOINT}/proc"
mount -o bind /sys "${MOUNTPOINT}/sys"
}

case ${TODO} in
	off)	off
		;;
	on)	on
		;;
	*)	echo "Usage: $0 {off|on}"
		exit 1
esac

echo "script done:" `date`

# EOF
