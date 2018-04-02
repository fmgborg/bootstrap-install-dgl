#!/bin/sh

SCRIPT=$0
NAME=$1
#IPv4=$2
#HDD=$3
#MEM=$4
#CUR_MEM=$5

CUSTOMIZATION_PATH_PREFIX="/usr/local"
CUSTOMIZATION_PATH="${CUSTOMIZATION_PATH_PREFIX}/etc/customization"
CUSTOMIZATION_FILE_INC="${CUSTOMIZATION_PATH}/customization.inc"
#CUSTOMIZATION_FILE_TXT="${CUSTOMIZATION_PATH}/customization.txt"
WORK_FILE=${CUSTOMIZATION_FILE_INC}

. ${WORK_FILE}
. /usr/local/etc/${CUSTOMIZATION}/generic.inc

THIS=`${BASENAME} ${SCRIPT}`

NOW=`${DATE}`

LOG="/tmp/${THIS}.log"

echo ${NOW}										>> ${LOG}

TEMPLATE="/usr/local/etc/libvirt/template/kvm--template-virtio.xml"

#. /usr/local/etc/libvirt/txt/beispiel.txt
#echo $MEM

CONFIG_SUFFIX_TXT="cfg"
CONFIG_SUFFIX_XML="xml"
CONFIG_BASE_PATH="/usr/local/etc/libvirt"
CONFIG_PATH_TXT="${CONFIG_BASE_PATH}/conf"
CONFIG_PATH_XML="${CONFIG_BASE_PATH}/qemu"
CONFIG_FILE_TXT="${CONFIG_PATH_TXT}/${NAME}.${CONFIG_SUFFIX_TXT}"
CONFIG_FILE_XML="${CONFIG_PATH_XML}/${NAME}.${CONFIG_SUFFIX_XML}"
if [ ! -e "${CONFIG_FILE_TXT}" ] ; then
	echo "file does not exist : ${CONFIG_FILE_TXT}"
	exit 1
fi
. ${CONFIG_FILE_TXT}
if [ -e "${CONFIG_FILE_XML}" ] ; then
	echo "file already exists : ${CONFIG_FILE_XML}"
	exit 1
fi
TMPFILE="/tmp/${NAME}"
# # todo
# touch ${TMPFILE}
# #${TOUCH} ${TMPFILE}
# ${RM} ${TMPFILE}

${CP} ${TEMPLATE} ${TMPFILE}

replace_template_var() {
#$CP ${TMPFILE} ${CONFIG_FILE_XML}
#${SED} -e "s/${OLD}/${NEW}/g" < ${CONFIG_FILE_XML} > ${TMPFILE}
${SED} -e "s/${OLD}/${NEW}/g" < ${TMPFILE} > ${CONFIG_FILE_XML}
#echo "${SED} -e s/${OLD}/${NEW}/g < ${TMPFILE} > ${CONFIG_FILE_XML}"
$CP ${CONFIG_FILE_XML} ${TMPFILE}
}

OLD="T_NAME"
NEW=${NAME}
replace_template_var 

OLD="T_UUID"
NEW=${UUID}
replace_template_var 

OLD="T_MEM"
NEW=${MEM}
replace_template_var 

OLD="T_CUR_MEM"
NEW=${CUR_MEM}
replace_template_var 

OLD="T_HDD"
NEW=${HDD}
replace_template_var 

OLD="T_MAC"
NEW=${MAC}
replace_template_var 

#cat ${TMPFILE}







exit 0

  <name>T_NAME</name>
  <uuid>T_UUID</uuid>
  <memory unit='KiB'>T_MEM</memory>
  <currentMemory unit='KiB'>T_CUR_MEM</currentMemory>
      <source dev='T_DEV_MAPPER_VG_VL'/>
      <mac address='T_MAC'/>

# EOF
