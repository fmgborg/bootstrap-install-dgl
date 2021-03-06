#!/bin/bash

# prepare customized installation files after debootstrap
# author:		Frank Guthausen
# date:			2015-10-04 22:08
# last modified:	2015-10-06

# --

# make changes here only

# disable test mode to obtain machine specific installation files
#TESTONLY="n"
TESTONLY="y"
# it is safe to deactivate test mode completely
TESTONLY="n"

# name of distribution
#DISTRIBUTION_CODE_NAME="jessie"
DISTRIBUTION_CODE_NAME="stretch"
#DCN=${DISTRIBUTION_CODE_NAME}

# installation path, default is /opt
WORK_PATH_TO_BOOTSTRAP="/opt"

# --

# do not make any changes beyond this line (unless you know what you do)

WORK_PATH_FROM_BOOTSTRAP="bootstrap/${DISTRIBUTION_CODE_NAME}"
BASE_PATH="${WORK_PATH_TO_BOOTSTRAP}/${WORK_PATH_FROM_BOOTSTRAP}"
CUSTOMIZATION_FILE="${BASE_PATH}/meta/etc/customizationname"
CUSTOMIZATION_NAME=`cat ${CUSTOMIZATION_FILE}`

GENERIC_META_INC="${BASE_PATH}/meta/sbin/generic-meta.inc"
. ${GENERIC_META_INC}

${ECHO} -e "\nChoose a configuration name first, then edit"
${ECHO} -e "${BASE_PATH}/meta/etc/customizationname\n"
${ECHO} -e "customizationname : ${fggreen}${CUSTOMIZATION_NAME}${normal}\n"

if [ "${TESTONLY}" = "y" ] ; then
	exit 1
fi

make_clean() {
	SYSTEM_PATH="${BASE_PATH}/system"
	GARBAGE_PATH="${BASE_PATH}/garbage"
	if [ -e ${GARBAGE_PATH} ] ; then
		${RM} -rf ${GARBAGE_PATH}
	fi
	if [ -e ${SYSTEM_PATH} ] ; then
		${MV} ${SYSTEM_PATH} ${GARBAGE_PATH}
	fi
	${MKDIR} ${SYSTEM_PATH}
}

make_clean

# block 01 : [2] customization master files
INPUT_PATH="${BASE_PATH}/master/templates/usr/local/etc/customization"
OUTPUT_PATH="${BASE_PATH}/system/customized/usr/local/etc/customization"
${MKDIR} -p ${OUTPUT_PATH}
#
FILENAME="customization.inc"
INPUT_FILE="${INPUT_PATH}/${FILENAME}"
OUTPUT_FILE="${OUTPUT_PATH}/${FILENAME}"
${SED} -e s/T_CUSTOMIZATION_NAME/${CUSTOMIZATION_NAME}/g < ${INPUT_FILE} > ${OUTPUT_FILE}
#
FILENAME="customization.txt"
INPUT_FILE="${INPUT_PATH}/${FILENAME}"
OUTPUT_FILE="${OUTPUT_PATH}/${FILENAME}"
${SED} -e s/T_CUSTOMIZATION_NAME/${CUSTOMIZATION_NAME}/g < ${INPUT_FILE} > ${OUTPUT_FILE}

# block 02 : [2] shell include files
INPUT_PATH="${BASE_PATH}/master/templates/usr/local/etc/jdoe"
OUTPUT_PATH="${BASE_PATH}/system/customized/usr/local/etc/${CUSTOMIZATION_NAME}"
${MKDIR} -p ${OUTPUT_PATH}
#
#${RSYNC} -au ${INPUT_PATH}/ ${OUTPUT_PATH}/
${CP} -apr ${INPUT_PATH}/* ${OUTPUT_PATH}/

# block 03 : [8] debconf preseed config
INPUT_PATH="${BASE_PATH}/master/generic/usr/local/etc/debconf/"
OUTPUT_PATH="${BASE_PATH}/system/customized/usr/local/etc/debconf/"
${MKDIR} -p ${OUTPUT_PATH}
${CP} -apr ${INPUT_PATH}/* ${OUTPUT_PATH}/

# block 04 : [3] issue issue.net motd
INPUT_PATH="${BASE_PATH}/master/templates/etc"
OUTPUT_PATH="${BASE_PATH}/system/customized/etc"
${MKDIR} -p ${OUTPUT_PATH}
#
FILENAME="issue"
INPUT_FILE="${INPUT_PATH}/${FILENAME}"
OUTPUT_FILE="${OUTPUT_PATH}/${FILENAME}"
${SED} -e s/T_CUSTOMIZATION_NAME/${CUSTOMIZATION_NAME}/g < ${INPUT_FILE} > ${OUTPUT_FILE}
#
FILENAME="issue.net"
INPUT_FILE="${INPUT_PATH}/${FILENAME}"
OUTPUT_FILE="${OUTPUT_PATH}/${FILENAME}"
${SED} -e s/T_CUSTOMIZATION_NAME/${CUSTOMIZATION_NAME}/g < ${INPUT_FILE} > ${OUTPUT_FILE}
#
FILENAME="motd"
INPUT_FILE="${INPUT_PATH}/${FILENAME}"
OUTPUT_FILE="${OUTPUT_PATH}/${FILENAME}"
${SED} -e s/T_CUSTOMIZATION_NAME/${CUSTOMIZATION_NAME}/g < ${INPUT_FILE} > ${OUTPUT_FILE}

# block 05 : [42] all generic files
INPUT_PATH="${BASE_PATH}/master/generic"
OUTPUT_PATH="${BASE_PATH}/system/customized"
${CP} -apr ${INPUT_PATH}/* ${OUTPUT_PATH}/

# block 06 :  [6] all precustomized files
INPUT_PATH="${BASE_PATH}/master/precustomized"
${CP} -apr ${INPUT_PATH}/* ${OUTPUT_PATH}/

# block 07 : [1] Debian Etch Debian.jpg
INPUT_PATH="${WORK_PATH_TO_BOOTSTRAP}/bootstrap/all/opt"
${CP} -apr ${INPUT_PATH} ${OUTPUT_PATH}

${ECHO} -e "${fgred}${bgyellow}Now${normal}: edit configuration files in"
${ECHO} -e "${BASE_PATH}/system/customized/etc/""\n"
${ECHO} -e '...and edit private ssh config and pub keys'"\n"

#${ECHO} -e 'edit /opt/bootstrap/jessie/system/customized/sbin/run-once-stage.00.01-pre-user.sh'"\n"
${ECHO} -e 'edit /opt/bootstrap/stretch/system/customized/sbin/run-once-stage.00.01-pre-user.sh'"\n"

# EOF
