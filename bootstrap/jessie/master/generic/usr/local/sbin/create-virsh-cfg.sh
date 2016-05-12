#!/bin/sh

SCRIPT=$0
NAME=$1
IPv4=$2
HDD=$3
MEM=$4
CUR_MEM=$5

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

CONFIG_SUFFIX="cfg"
CONFIG_BASE_PATH="/usr/local/etc/libvirt"
CONFIG_PATH="${CONFIG_BASE_PATH}/conf"
CONFIG_FILE="${CONFIG_PATH}/${NAME}.${CONFIG_SUFFIX}"
if [ -e "${CONFIG_FILE}" ] ; then
	echo "file already exists : ${CONFIG_FILE}"
	exit 1
fi
RAM=1048576
#CUR_RAM=${RAM}
if [ "${MEM}" = "" ] ; then
	MEM=${RAM}
fi
CUR_MEM=${MEM}
UUID=`uuidgen`

#MAC_PREFIX_KVM="52:54:00"

BYTE2=`echo ${IPv4} | cut -d . -f 2`
BYTE3=`echo ${IPv4} | cut -d . -f 3`
BYTE4=`echo ${IPv4} | cut -d . -f 4`
#echo $BYTE2 $BYTE3 $BYTE4

check_byte_range(){
#
#echo check BYTE${N}
#
if [ ${BYTE} -eq ${BYTE} ] 2> /dev/null ; then
	#echo BYTE${N} yes
	echo BYTE${N} yes								>> ${LOG}
else
	echo "BYTE${N} value '${BYTE}' no integer"
	exit 1
fi
#
if [ ${BYTE} -ge 0 ] 2> /dev/null && [ ${BYTE} -le 255 ] 2> /dev/null ; then
	echo BYTE${N} ok								>> ${LOG}
else
	echo "BYTE${N} value '${BYTE}' not in range 0-255"
	exit 1
fi
MAC_BYTE=`printf "%02x" ${BYTE}`
MAC="${MAC}:${MAC_BYTE}"
}

MAC=${MAC_PREFIX_KVM}

N=2
BYTE=${BYTE2}
check_byte_range
N=3
BYTE=${BYTE3}
check_byte_range
N=4
BYTE=${BYTE4}
check_byte_range

#echo $MAC

#LAST_MAC_BYTE=`printf "%x" ${LAST_IP_BYTE}`
#echo "NAME=${NAME} -- hard disk drive :$HD -- UUID:$UUID -- MEM:$MEM -- CUR_MEM:${CUR_MEM}"


#echo "/" | sed -e 's/\//\\\\\//g'
### #HD=${HDD}
### #echo HD : $HD
### #echo
### #
### #HDD=`echo $HD | sed -e 's/\//A\\\\B\//g'`
### #echo $HD | sed -e 's/\//A\\\\B\//g'
### #echo $HDD
### #echo
### #
### #HDD=`echo $HD | sed -e 's/\//1\\\\2\\\\3\//g'`
### #echo $HD | sed -e 's/\//1\\\\2\\\\3\//g'
### #echo $HDD
### #echo
### #
### #HDD=`echo $HD | sed -e 's/\//\\\\2\\\\3\//g'`
### #echo $HD | sed -e 's/\//\\\\2\\\\3\//g'
### #echo `echo $HD | sed -e 's/\//\\\\2\\\\3\//g'`
### #echo $HDD
### #echo
### #
### #echo FF
### #FF=`echo $HD | sed -e 's/\//XY/g'`
### #echo $HD | sed -e 's/\//XY/g'
### #echo $FF
### #echo
### #echo GG
### #GG=`echo $FF | sed -e 's/XY/\\\\\\\\ZY/g'`
### #echo $FF | sed -e 's/XY/\\\\\\\\ZY/g'
### #echo $GG
### #echo
### #
### #HDD=`echo $HD | sed -e 's/\//\\\\\\\\\\\\\\\\\//g'`
### #echo $HD | sed -e 's/\//A\\\\\\\\\\\\\\\\B\//g'
### #echo $HDD
### #echo
### #
### #exit

HD=${HDD}
HDD=`echo $HD | sed -e 's/\//\\\\\\\\\\\\\\\\\//g'`

echo "NAME=${NAME}"		>> ${CONFIG_FILE}
echo "UUID=${UUID}"		>> ${CONFIG_FILE}
echo "MEM=${MEM}"		>> ${CONFIG_FILE}
echo "CUR_MEM=${CUR_MEM}"	>> ${CONFIG_FILE}
echo "HDD=${HDD}"		>> ${CONFIG_FILE}
echo "MAC=${MAC}"		>> ${CONFIG_FILE}

#echo "Name: $NAME IPv4: $IP"
#printf ""

exit 0

  <name>T_NAME</name>
  <uuid>T_UUID</uuid>
  <memory unit='KiB'>T_MEM</memory>
  <currentMemory unit='KiB'>T_CUR_MEM</currentMemory>
      <source dev='T_DEV_MAPPER_VG_VL'/>
      <mac address='T_MAC'/>

# EOF
