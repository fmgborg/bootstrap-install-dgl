#!/bin/sh

# 2015-02-16 00:56

CUSTOMIZATION_FILE_INC="/usr/local/etc/customization/customization.inc"
#CUSTOMIZATION_FILE_TXT="/usr/local/etc/customization/customization.txt"
WORK_FILE=${CUSTOMIZATION_FILE_INC}

. ${WORK_FILE}
. /usr/local/etc/${CUSTOMIZATION}/generic.inc

check_customization() {
${ECHO} "CUSTOMIZATION_FILE content : "
${ECHO} '---->'
${CAT} ${WORK_FILE}
${ECHO} '<----'
${ECHO} CUSTOMIZATION : ${CUSTOMIZATION}
}

check_customization

# EOF
