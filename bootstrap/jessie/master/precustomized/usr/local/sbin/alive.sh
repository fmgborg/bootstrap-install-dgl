#!/bin/sh

# 2014-05-04
# 2015-10-06

# run this script each 2 minutes via cron
# This script should be run automatically after boot/reboot.

CUSTOMIZATION_PATH_PREFIX="/usr/local"
CUSTOMIZATION_PATH="${CUSTOMIZATION_PATH_PREFIX}/etc/customization"
CUSTOMIZATION_FILE_INC="${CUSTOMIZATION_PATH}/customization.inc"
#CUSTOMIZATION_FILE_TXT="${CUSTOMIZATION_PATH}/customization.txt"
WORK_FILE=${CUSTOMIZATION_FILE_INC}

. ${WORK_FILE}
. /usr/local/etc/${CUSTOMIZATION}/generic.inc

NOW=`${DATE}`

LOGPATH="/var/log/${CUSTOMIZATION}"
LOGFILE="${CUSTOMIZATION}-alive.log"
LOGGING="${LOGPATH}/${LOGFILE}"

if [ ! -d ${LOGPATH} ] ; then
	${MKDIR} -p ${LOGPATH}
fi

${ECHO} ${NOW}						2>&1 >> ${LOGGING}

# EOF
