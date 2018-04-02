#! /bin/sh

# 2014-06-23 16:32
# 2015-02-15 19:41

# This script should be run automatically after boot/reboot.

CUSTOMIZATION_PATH_PREFIX="/usr/local"
CUSTOMIZATION_PATH="${CUSTOMIZATION_PATH_PREFIX}/etc/customization"
CUSTOMIZATION_FILE_INC="${CUSTOMIZATION_PATH}/customization.inc"
#CUSTOMIZATION_FILE_TXT="${CUSTOMIZATION_PATH}/customization.txt"
WORK_FILE=${CUSTOMIZATION_FILE_INC}

. ${WORK_FILE}
. /usr/local/etc/${CUSTOMIZATION}/generic.inc

LOGPATH="/var/log/${CUSTOMIZATION}"
LOGFILE="${CUSTOMIZATION}-bridge.log"
LOGGING="${LOGPATH}/${LOGFILE}"

BRIDGE_NAME_EXT="brext"
BRIDGE_IP_EXT="10.77.1.254"
BRIDGE_NETMASK_EXT="255.255.255.0"

BRIDGE_NAME_INT="brint"
BRIDGE_IP_INT="10.192.168.254"
BRIDGE_NETMASK_INT="255.255.255.0"

create_bridge() {
	${BRCTL} addbr ${BRIDGENAME}
	${BRCTL} stp ${BRIDGENAME} off
	#brctl sethello brext 0
	#echo "set hello timer failed: Numerical result out of range"
	${BRCTL} setfd ${BRIDGENAME} 0
}

if [ ! -d ${LOGPATH} ] ; then
        ${MKDIR} -p ${LOGPATH}
fi

${ECHO} Start						2>&1 | tee -a ${LOGGING}
NOW=`${DATE}`
${ECHO} ${NOW}						2>&1 | tee -a ${LOGGING}
${ECHO} .						2>&1 | tee -a ${LOGGING}
${BRCTL} show						2>&1 | tee -a ${LOGGING}
${ECHO} .						2>&1 | tee -a ${LOGGING}

BRIDGENAME=${BRIDGE_NAME_EXT}
create_bridge
IP=${BRIDGE_IP_EXT}
NETMASK=${BRIDGE_NETMASK_EXT}
# q'nd
${IFCONFIG} ${BRIDGENAME} ${IP} netmask ${NETMASK} up

BRIDGENAME=${BRIDGE_NAME_INT}
create_bridge
IP=${BRIDGE_IP_INT}
NETMASK=${BRIDGE_NETMASK_INT}
# q'nd
${IFCONFIG} ${BRIDGENAME} ${IP} netmask ${NETMASK} up

${BRCTL} show						2>&1 | tee -a ${LOGGING}
${ECHO} .						2>&1 | tee -a ${LOGGING}
${ECHO} Stop						2>&1 | tee -a ${LOGGING}
${ECHO} "-"						2>&1 | tee -a ${LOGGING}

# EOF
