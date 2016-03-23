#!/bin/sh

# 2016-03-23 14:22

# this script should run once or twice a day on average

CUSTOMIZATION_PATH_PREFIX="/usr/local"
CUSTOMIZATION_PATH="${CUSTOMIZATION_PATH_PREFIX}/etc/customization"
CUSTOMIZATION_FILE_INC="${CUSTOMIZATION_PATH}/customization.inc"
WORK_FILE=${CUSTOMIZATION_FILE_INC}

. ${WORK_FILE}
. /usr/local/etc/${CUSTOMIZATION}/generic.inc

LOGPATH="/var/log/${CUSTOMIZATION}"
LOGFILE="${CUSTOMIZATION}-aptitude-safe-upgrade.log"
LOGGING="${LOGPATH}/${LOGFILE}"

if [ ! -d ${LOGPATH} ] ; then
        ${MKDIR} -p ${LOGPATH}
fi

NOW=`${DATE}`

${ECHO} -e ".\nStart"					2>&1 | tee -a ${LOGGING}
${ECHO} ${NOW}						2>&1 | tee -a ${LOGGING}
${APTITUDE} update					2>&1 | tee -a ${LOGGING}
${APTITUDE} -y safe-upgrade				2>&1 | tee -a ${LOGGING}
${ECHO} -e ".\nStop"					2>&1 | tee -a ${LOGGING}

# EOF
