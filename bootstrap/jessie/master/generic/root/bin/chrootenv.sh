#!/bin/sh

TODO=$1

MOUNTPOINT="/mnt"

off() {
echo "chrootenv off"
umount ${MOUNTPOINT}/sys
umount ${MOUNTPOINT}/proc
umount ${MOUNTPOINT}/dev/pts
umount ${MOUNTPOINT}/dev
}

on() {
echo "chrootenv on"
mount -o bind /dev	"${MOUNTPOINT}/dev"
mount -o bind /dev/pts	"${MOUNTPOINT}/dev/pts"
mount -o bind /proc	"${MOUNTPOINT}/proc"
mount -o bind /sys	"${MOUNTPOINT}/sys"
}

alternate() {
# just documentation
mount -t devfs devfs	/mnt//dev
mount -o bind /dev/pts	/mnt//dev/pts
mount -t proc  proc	/mnt/proc/
mount -t sysfs sys	/mnt/sys/
}

inside_chroot() {
# just documentation
mount -t devfs none /dev
mount -t proc  none /proc
}

outside_chroot() {
# just documentation
mount -t proc none /mnt/proc
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
