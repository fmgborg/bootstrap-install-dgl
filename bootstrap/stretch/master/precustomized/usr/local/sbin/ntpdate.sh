#!/bin/sh

# 2014-05-04 03:33
# 2015-02-09 01:50
# 2015-02-19 00:05

# run this script each 30 minutes via cron

CUSTOMIZATION_PATH_PREFIX="/usr/local"
CUSTOMIZATION_PATH="${CUSTOMIZATION_PATH_PREFIX}/etc/customization"
CUSTOMIZATION_FILE_INC="${CUSTOMIZATION_PATH}/customization.inc"
#CUSTOMIZATION_FILE_TXT="${CUSTOMIZATION_PATH}/customization.txt"
WORK_FILE=${CUSTOMIZATION_FILE_INC}

. ${WORK_FILE}
. /usr/local/etc/${CUSTOMIZATION}/generic.inc

NOW=`${DATE}`

NTPOPTION="-u"
NTPSOURCE="1.de.pool.ntp.org"

LOGPATH="/var/log/${CUSTOMIZATION}"
LOGFILE="${CUSTOMIZATION}-alive.log"
LOGGING="${LOGPATH}/${LOGFILE}"

if [ ! -d ${LOGPATH} ] ; then
	${MKDIR} -p ${LOGPATH}
fi

${NTPDATE} ${NTPOPTION} ${NTPSOURCE}			2>&1 >>	${LOGGING}

# EOF
