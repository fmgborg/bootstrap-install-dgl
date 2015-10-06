#! /bin/sh

# 2015-10-06

# This script should be run automatically after boot/reboot.

CUSTOMIZATION_PATH_PREFIX="/usr/local"
CUSTOMIZATION_PATH="${CUSTOMIZATION_PATH_PREFIX}/etc/customization"
CUSTOMIZATION_FILE_INC="${CUSTOMIZATION_PATH}/customization.inc"
#CUSTOMIZATION_FILE_TXT="${CUSTOMIZATION_PATH}/customization.txt"
WORK_FILE=${CUSTOMIZATION_FILE_INC}

. ${WORK_FILE}
. /usr/local/etc/${CUSTOMIZATION}/generic.inc

BOOTLOGFILE="${CUSTOMIZATION}-boot.log"
BOOTLOGGING="${LOGPATH}/${BOOTLOGFILE}"

todo() {
	echo ${fgred}Todo:
	echo bootlog
	echo xen domU start${normal}...
}

dummy() {
	echo DUMMY ${WHICH} $0
	echo todo
	echo
}

bootlog() {
	NOW=`${DATE}`
	${ECHO} ${NOW}					2>&1 | tee -a ${BOOTLOGGING}
	${ECHO} "."					2>&1 | tee -a ${BOOTLOGGING}
}

create_a_bridge() {
	${BRCTL} addbr ${BRIDGENAME}
	${BRCTL} stp ${BRIDGENAME} off
	#brctl sethello brext 0
	#echo "set hello timer failed: Numerical result out of range"
	${BRCTL} setfd ${BRIDGENAME} 0
}

create_bridges() {
	LOGFILE="${CUSTOMIZATION}-bridge.log"
	LOGGING="${LOGPATH}/${LOGFILE}"
	${ECHO} Start					2>&1 | tee -a ${LOGGING}
	NOW=`${DATE}`
	${ECHO} ${NOW}					2>&1 | tee -a ${LOGGING}
	${ECHO} .					2>&1 | tee -a ${LOGGING}
	${BRCTL} show					2>&1 | tee -a ${LOGGING}
	${ECHO} .					2>&1 | tee -a ${LOGGING}
	BRIDGENAME=brext
	create_a_bridge
	BRIDGENAME=brint
	create_a_bridge
	${BRCTL} show					2>&1 | tee -a ${LOGGING}
	${ECHO} .					2>&1 | tee -a ${LOGGING}
	${ECHO} Stop					2>&1 | tee -a ${LOGGING}
	${ECHO} "-"					2>&1 | tee -a ${LOGGING}
}

network() {
	# q'nd
	ifconfig brext 10.1.1.254 netmask 255.255.255.0 up
	# q'nd
	ifconfig brint 10.192.168.254 netmask 255.255.255.0 up
	# q'nd
	MYIP=10.10.10.10
	iptables -t nat -A POSTROUTING -s 10.1.1.0/24 -o br0 -j SNAT --to-source ${MYIP}	# q'nd
	# q'nd
	## prototyp openvpn
	iptables -t nat -A PREROUTING -p udp -i br0 -d ${MYIP} --dport 1194 -j DNAT --to 10.1.1.1:1194
	iptables -t nat -A PREROUTING -p udp -i br0 -d ${MYIP} --dport 1195 -j DNAT --to 10.1.1.1:1195
}

bootlog
#create_bridges		# example
##network		# example

# EOF
