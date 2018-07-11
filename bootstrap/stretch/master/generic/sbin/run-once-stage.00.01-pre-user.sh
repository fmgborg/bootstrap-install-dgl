#!/bin/bash

# multipurpose installation script
# author:			Frank Guthausen
# date:				2008-2015
# this structure:		2015-10-05
# install + reconfiguration:	2016-05-05
# last modification:		2018-03-15

PATH="${PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

#echo TERM : ${TERM}
#sleep 1
#exit 1
#TERM=screen
#TERM=linux

# Change this flag to edit some configuration files interactively or not.
# safety lock
# temporarily removed 2016-05-06
EDIT_CONFIGURATION_INTERACTIVE="n"
#EDIT_CONFIGURATION_INTERACTIVE="y"
#EDIT_CONFIGURATION_INTERACTIVE="undefined"
ECI=${EDIT_CONFIGURATION_INTERACTIVE}

# Change this to your network needs.
IPv4_PREFERRED="y"
#IPv4_PREFERRED="n"

# Change this for shell user with role system administrator (NIY).
DEFUSER="sysadmin"

# Change this for the htaccess user (NIY).
TMPUSER="tmpuser"

# Change INSTALL_RESSOURCES_PATH to your needs, but changes will appear
# in different locations. Default is having bootstrap/ in /opt/ as shown
# here.
# 
#INSTALL_RESSOURCES_PATH="/opt/install/system"
#INSTALL_RESSOURCES_PATH="/opt/bootstrap/jessie/system"
#INSTALL_RESSOURCES_PATH="/opt/bootstrap/jessie/system/customized"
INSTALL_RESSOURCES_PATH="/opt/bootstrap/stretch/system/customized"
IRP=${INSTALL_RESSOURCES_PATH}

#CUSTOMIZATION_FILE="${IRP}/customized/usr/local/etc/customization/customization.txt"
CUSTOMIZATION_FILE="${IRP}/usr/local/etc/customization/customization.txt"

DEBCONF_PRESEED_PATH="${IRP}/usr/local/etc/debconf"
DPP="${DEBCONF_PRESEED_PATH}"
DEBCONF_PRESEED_FILE="none"
DPFILE="${DEBCONF_PRESEED_FILE}"
DPFLAG="n"

# installation interactive or not
# this is redundant, because it is set by ECI value in c01_check_edit
if [ "${ECI}" = "y" ] ; then
	INSTALL="aptitude install"
else
	INSTALL="aptitude -y install"
fi

# WARNING: do not edit beyond this line unless you really know what you are doing

c00_check_customization() {
echo
echo "check for : ${CUSTOMIZATION_FILE}"
if [ ! -e "${CUSTOMIZATION_FILE}" ] ; then
	echo
	echo "customization file not found:"
	echo "${CUSTOMIZATION_FILE}"
	echo "exit $0"
	echo
	exit 1
else
	CUSTOMIZATION=`cat "${CUSTOMIZATION_FILE}"`
	GENERIC_INC="${IRP}/usr/local/etc/${CUSTOMIZATION}/generic.inc"
	SHELLCOLORS_INC="${IRP}/usr/local/etc/${CUSTOMIZATION}/shellcolors.inc"
	if [ -f ${SHELLCOLORS_INC} ] ; then
		echo "found shellcolors.inc : ${SHELLCOLORS_INC}"
		. ${SHELLCOLORS_INC}
		SCI="y"
	else
		echo "missing shellcolors.inc : ${SHELLCOLORS_INC}"
		SCI="n"
	fi
	if [ -f ${GENERIC_INC} ] ; then
		echo "found generic.inc : ${GENERIC_INC}"
		. ${GENERIC_INC}
		${ECHO} -e "found customization :  ${fggreen}${CUSTOMIZATION}${normal}"
		${ECHO} -e "found ${fggreen}${GENERIC_INC}${normal}"
	else
		echo "not found : ${GENERIC_INC}"
		echo "found customizaton : ${CUSTOMIZATION}"
		echo "exit $0"
		echo
		exit 1
	fi
fi
}

c01_check_edit() {
case ${ECI} in
	y)
		echo
		echo "edit configuration interactively : yes"
		INSTALL="aptitude install"
		echo
	;;
	n)
		echo
		echo "edit configuration interactively : no"
		INSTALL="aptitude -y install"
		echo
	;;
	*)
		echo
		echo "edit configuration interactively : not well-defined"
		echo "exit $0"
		echo
		exit 1
	;;
esac
}


c02_configfile() {
#LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
LF=${LOCAL_FILE}
#if [ -e ${LF} ] ; then
if [ -e ${IRP}${LF} ] ; then
	rsync -a "${IRP}${LF}" ${LF}
	if [ "${ECI}" = "y" ] ; then
		vim ${LF}
	fi
else
#	echo "file not found : ${LF}"
	${ECHO} -e "${fgred}file not found${normal} : ${IRP}${LF}"
fi
}


mf00_install() {
# old: this master function needs the name of the package, a reconfigure flag and the name of the debconf preseed file
# new: this master function needs the name of the package
#
# DRFLAG : dpkg-reconfigure flag -- NIY
# DPFILE : debconf preseed file
# DPFLAG : debconf preseed flag
#
OLD_DPFLAG=${DPFLAG}
OLD_DPFILE=${DPFILE}
# we flag by existence of ${DPFILE}, thus DPFLAG ist always "y"
DPFLAG="y"
DPFILE="${DPP}/debconf.seed--${PACKAGE}.txt"
if [ "${DPFLAG}" = "y" ] && [ -e "${DPFILE}" ] ; then
	${ECHO} -e "${fggreen}${DEBCONF_SET_SELECTIONS} ${DPFILE}${normal}"
	${DEBCONF_SET_SELECTIONS} ${DPFILE}
else
	${ECHO} -e "${fgred}${DEBCONF_SET_SELECTIONS} ${DPFILE}${normal}"
fi
# always install, no ifclause here
#if [ "${ECI}" = "y" ] ; then
#	${INSTALL} ${PACKAGE}
#	#if [ "${DRFLAG}" = "y" ] ; then
#	#	${DPKG_RECONFIGURE} ${PACKAGE}
#	#fi
#else
#	# DPFLAG is never "y" but always "n" for now
#	if [ "${DPFLAG}" = "y" ] && [ -e "${DPFILE}" ] ; then
#		${DEBCONF_SET_SELECTIONS} ${DPFILE}
#	fi
#	${INSTALL} ${PACKAGE}
#fi
${INSTALL} ${PACKAGE}
DPFLAG=${OLD_DPFLAG}
DPFILE=${OLD_DPFILE}
}

mf01_reconfigure() {
OLD_DPFILE=${DPFILE}
DPFILE="${DPP}/debconf.seed--${PACKAGE}.txt"
${DEBCONF_SET_SELECTIONS} ${DPFILE}
if [ "${ECI}" = "y" ] ; then
	dpkg-reconfigure ${PACKAGE}
else
	dpkg-reconfigure -f noninteractive ${PACKAGE}
fi
DPFILE=${OLD_DPFILE}
}

mf02_preconfigure() {
OLD_DPFLAG=${DPFLAG}
OLD_DPFILE=${DPFILE}
# we flag by existence of ${DPFILE}, thus DPFLAG ist always "y"
DPFLAG="y"
DPFILE="${DPP}/debconf.seed--${PACKAGE}.txt"
if [ "${DPFLAG}" = "y" ] && [ -e "${DPFILE}" ] ; then
	${ECHO} -e "${fggreen}${DEBCONF_SET_SELECTIONS} ${DPFILE}${normal}"
	${DEBCONF_SET_SELECTIONS} ${DPFILE}
else
	${ECHO} -e "${fgred}${DEBCONF_SET_SELECTIONS} ${DPFILE}${normal}"
fi
DPFLAG=${OLD_DPFLAG}
DPFILE=${OLD_DPFILE}
}


f00_safe_orig_config_file_apt_sources() {
mv /etc/apt/sources.list /etc/apt/sources.list.orig
cp -a /etc/apt/sources.list.orig /etc/apt/sources.list
}

f01_prepare_apt() {
APT_CONF="/etc/apt/apt.conf"
if [ -e ${APT_CONF} ] ; then
	# WARNING: does not work with BSD -- 'cp -p' instead
	mv ${APT_CONF} ${APT_CONF}.orig
	cp -a ${APT_CONF}.orig ${APT_CONF}
fi
echo 'APT::Cache-Limit "67108864";'                                     >> /etc/apt/apt.conf
echo 'APT::Install-Recommends "0";'                                     >> /etc/apt/apt.conf
echo 'APT::Install-Suggests "0";'                                       >> /etc/apt/apt.conf
echo 'Aptitude::Recommends-Important "false";'                          >> /etc/apt/apt.conf
echo '//Acquire::http::Proxy "http://aptcache:3142/apt-cacher/";'       >> /etc/apt/apt.conf
if [ "${IPv4_PREFERRED}" = "y" ] ; then
	echo 'Acquire::ForceIPv4 "true";'				>> /etc/apt/apt.conf.d/99force-ipv4
	# getaddressinfo
	LOCAL_FILE="/etc/gai.conf"
	LF=${LOCAL_FILE}
	j=${LF} ; mv ${j} ${j}.orig ; cp -a ${j}.orig ${j}
	cp -a "${IRP}${LF}" ${LF}
fi
}

f02_use_aptitude() {
apt-get -y install aptitude
aptitude update
#aptitude safe-upgrade
if [ "${ECI}" = "y" ] ; then
	aptitude safe-upgrade
else
	aptitude -y safe-upgrade
fi
}

f03_prepare_environment() {
#
#dpkg-reconfigure debconf
PACKAGE="debconf"
#OLD_DPFILE=${DPFILE}
#DPFILE="${DPP}/debconf.seed--${PACKAGE}.txt"
#${DEBCONF_SET_SELECTIONS} ${DPFILE}
#if [ "${ECI}" = "y" ] ; then
#	dpkg-reconfigure ${PACKAGE}
#else
#	dpkg-reconfigure -f noninteractive ${PACKAGE}
#fi
#DPFILE=${OLD_DPFILE}
mf01_reconfigure
#
#${INSTALL} locales
PACKAGE="locales"
# flag and file are handled in (master)function mf00_install
#OLD_DPFLAG=${DPFLAG}
#OLD_DPFILE=${DPFILE}
# we do not use DPFLAG and set the seed explicitely for now
#DPFLAG="y"
#DPFILE="${DPP}/debconf.seed--locales.txt"
#DPFILE="${DPP}/debconf.seed--${PACKAGE}.txt"
#${DEBCONF_SET_SELECTIONS} ${DPFILE}
# we call the masterfunction
mf00_install
#${INSTALL} ${PACKAGE}
#DPFLAG=${OLD_DPFLAG}
#DPFILE=${OLD_DPFILE}
#
#dpkg-reconfigure locales
PACKAGE="locales"
#OLD_DPFILE=${DPFILE}
#DPFILE="${DPP}/debconf.seed--${PACKAGE}.txt"
#${DEBCONF_SET_SELECTIONS} ${DPFILE}
#if [ "${ECI}" = "y" ] ; then
#	dpkg-reconfigure ${PACKAGE}
#else
#	dpkg-reconfigure -f noninteractive ${PACKAGE}
#fi
#DPFILE=${OLD_DPFILE}
mf01_reconfigure
#
# #dpkg-reconfigure debconf
# PACKAGE="debconf"
# #OLD_DPFILE=${DPFILE}
# #DPFILE="${DPP}/debconf.seed--${PACKAGE}.txt"
# #${DEBCONF_SET_SELECTIONS} ${DPFILE}
# #if [ "${ECI}" = "y" ] ; then
# #	dpkg-reconfigure ${PACKAGE}
# #else
# #	dpkg-reconfigure -f noninteractive ${PACKAGE}
# #fi
# #DPFILE=${OLD_DPFILE}
# mf01_reconfigure
#
mv /etc/timezone /etc/timezone.orig
#dpkg-reconfigure tzdata
PACKAGE="tzdata"
#OLD_DPFILE=${DPFILE}
#DPFILE="${DPP}/debconf.seed--${PACKAGE}.txt"
#${DEBCONF_SET_SELECTIONS} ${DPFILE}
#if [ "${ECI}" = "y" ] ; then
#	dpkg-reconfigure ${PACKAGE}
#else
#	dpkg-reconfigure -f noninteractive ${PACKAGE}
#fi
#DPFILE=${OLD_DPFILE}
mf01_reconfigure
#
#${INSTALL} rsync
PACKAGE="rsync"
mf00_install
#
# prevent daemons to start inside of chroot
## no trouble with 'service stop $foo' before leaving and umounting
LOCAL_FILE="/usr/sbin/policy-rc.d"
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
# remove systemd init system
## description is not completely correct:
## http://without-systemd.org/wiki/index.php/How_to_remove_systemd_from_a_Debian_jessie/sid_installation
## transitional package sysvinit contains fallback SysV init binary
## usage as kernel command line parameter: init=/lib/sysvinit/init
# this is a special case, not with mf00_install
${INSTALL} sysvinit-core systemd-sysv-
${INSTALL} pmisc
#
${ECHO} -e "${fgred}remove systemd now${normal}"
sleep 2
aptitude remove systemd
}

f04_install_editor() {
#${INSTALL} vim
PACKAGE="vim"
mf00_install
if [ "${ECI}" = "y" ] ; then
	#update-alternatives --config editor
	${UPDATE_ALTERNATIVES} --config editor
else
	#update-alternatives --set editor /usr/bin/vim.basic
	${UPDATE_ALTERNATIVES} --set editor /usr/bin/vim.basic
fi
LOCAL_FILE="/root/.selected_editor"
# not anymore used in stretch?
# LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
# vim configuration before we modify sources.list
LOCAL_FILE="/root/.vimrc"
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
LOCAL_PATH="/root/.vim/"				# with /
LP=${LOCAL_PATH} && rsync -a "${IRP}${LP}" ${LP}
}

f05_reconfigure_apt_sources() {
#vi /etc/apt/sources.list
LOCAL_FILE="/etc/apt/sources.list"
#LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
#if [ "${ECI}" == "y" ] ; then
#	vim ${LF}
#fi
c02_configfile
aptitude update
#
# security upgrades now
${ECHO} -e "${fgred}security upgrades now${normal}"
if [ "${ECI}" = "y" ] ; then
	aptitude safe-upgrade
else
	aptitude -y safe-upgrade
fi
${ECHO} -e "${fggreen}security upgrades done${normal}"
}

f06_install_tools_l01_elementary() {
#
${INSTALL} pwgen
RANDOM_PW_FILE="/root/random_install_password"
RANDOM_PW="`pwgen -1`"
RANDOM_PW="${RANDOM_PW}`pwgen -1`"
RANDOM_PW="${RANDOM_PW}`pwgen -1`"
echo ${RANDOM_PW} > ${RANDOM_PW_FILE}
#
PACKAGE="cryptsetup"
#${INSTALL} cryptsetup
mf00_install
#
${INSTALL} busybox
${INSTALL} initramfs-tools
#
#PACKAGE="keyboard-configuration"
#mf02_preconfigure
#PACKAGE="console-data"
#mf02_preconfigure
#PACKAGE="console-common"
#mf02_preconfigure
#PACKAGE="console-setup"
#mf02_preconfigure
#
${INSTALL} kbd
#
PACKAGE="keyboard-configuration"
#mf02_preconfigure
mf00_install
mv /etc/default/keyboard /etc/default/keyboard.orig
LOCAL_FILE="/etc/default/keyboard"
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
#
PACKAGE="console-data"
#${INSTALL} console-data
mf00_install
#
PACKAGE="console-common"
#${INSTALL} console-common
mf00_install
#
# predefine config file for comparision
LOCAL_FILE="/etc/default/console-setup"
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
PACKAGE="console-setup"
#${INSTALL} console-setup
mf00_install
#dpkg-reconfigure console-setup
#mf01_reconfigure
mv /etc/default/console-setup /etc/default/console-setup.orig
LOCAL_FILE="/etc/default/console-setup"
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
#
${INSTALL} lvm2
${INSTALL} bridge-utils
}

f07_safe_orig_config_files_elementary() {
# mountpoint for / via bind, optional used in fstab
LOOPBACKDIR="/srv/loopback"
mkdir ${LOOPBACKDIR}
#
#FILELIST="fstab crypttab hosts hostname network/interfaces shadow rc.local inittab issue issue.net motd"
# no /etc/inittab in Debian Jessie anymore when using systemd-sysv
#FILELIST="fstab crypttab hosts hostname network/interfaces shadow rc.local issue issue.net motd"
# but since we've installed sysvinit-core /etc/inittab is back
FILELIST="fstab crypttab hosts hostname network/interfaces shadow rc.local inittab issue issue.net motd modules"
for i in `echo $FILELIST` ; do j="/etc/${i}" ; mv ${j} ${j}.orig ; cp -a ${j}.orig ${j} ; done
find /etc/ -name "*.orig"
#vi /etc/hostname
LOCAL_FILE="/etc/hostname"
#LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
c02_configfile
#vi /etc/hosts
LOCAL_FILE="/etc/hosts"
#LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
c02_configfile
#vi /etc/fstab
LOCAL_FILE="/etc/fstab"
#LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
c02_configfile
#vi /etc/crypttab
LOCAL_FILE="/etc/crypttab"
#LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
c02_configfile
#vi /etc/network/interfaces
LOCAL_FILE="/etc/network/interfaces"
#LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
c02_configfile
#
LOCAL_FILE="/etc/modules"
#LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
c02_configfile
#
#echo --------------------------------------------------------------------------
#
LOCAL_FILE="/etc/inittab"
c02_configfile
#
#vi /etc/issue
LOCAL_FILE="/etc/issue"
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
#c02_configfile
#vi /etc/issue.net
LOCAL_FILE="/etc/issue.net"
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
#c02_configfile
#
LOCAL_FILE="/etc/motd"
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
#c02_configfile
#echo --------------------------------------------------------------------------
# customization is done in function c00...
#CUSTOMIZATION="fmg"
#CUSTOMIZATION=`cat "${CUSTOMIZATION_FILE}"`
#LOCAL_FILE="/usr/local/sbin/${CUSTOMIZATION}-boot.sh"
LOCAL_FILE="/usr/local/sbin/boot.sh"
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
#c02_configfile
#vi /etc/rc.local
LOCAL_FILE="/etc/rc.local"
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
#c02_configfile
#echo --------------------------------------------------------------------------
# Xen
#echo vi /etc/inittab
LOCAL_FILE="/etc/inittab.xen"
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
#echo --------------------------------------------------------------------------
}

f08_install_ssh() {
${INSTALL} openssl
#
PACKAGE="ca-certificates"
#${INSTALL} ca-certificates
mf00_install
#
${INSTALL} ssl-cert
# no stunnel4 now, maybe later
#aptitude -y -s install stunnel4
${INSTALL} -s stunnel4
${INSTALL} ssh
${INSTALL} krb5-locales ncurses-term tcpd
${INSTALL} xauth
FINGERPRINTLOG="/root/sshd-chroot-keys.txt"
ssh-keygen -l -f /etc/ssh/ssh_host_dsa_key	>> ${FINGERPRINTLOG}
ssh-keygen -l -f /etc/ssh/ssh_host_rsa_key	>> ${FINGERPRINTLOG}
ssh-keygen -l -f /etc/ssh/ssh_host_ecdsa_key	>> ${FINGERPRINTLOG}
ssh-keygen -l -f /etc/ssh/ssh_host_ed25519_key	>> ${FINGERPRINTLOG}
#
mv /etc/ssh/sshd_config /etc/ssh/sshd_config.orig
LOCAL_FILE="/etc/ssh/sshd_config"
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
#
LOCAL_FILE="/etc/default/ssh2"
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
LOCAL_FILE="/etc/init.d/ssh2"
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
LOCAL_FILE="/etc/ssh/ssh2d_config"
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
LOCAL_FILE="/usr/local/sbin/ssh2d"
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
#
LOCAL_FILE="/etc/default/ssh3"
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
LOCAL_FILE="/etc/init.d/ssh3"
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
LOCAL_FILE="/etc/ssh/ssh3d_config"
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
LOCAL_FILE="/usr/local/sbin/ssh3d"
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
#
LOCAL_FILE="/etc/default/ssh4"
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
LOCAL_FILE="/etc/init.d/ssh4"
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
LOCAL_FILE="/etc/ssh/ssh4d_config"
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
LOCAL_FILE="/usr/local/sbin/ssh4d"
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
#
update-rc.d ssh2 defaults
update-rc.d ssh3 defaults
update-rc.d ssh4 defaults
}

f09_activate_root_password() {
#mv /etc/shadow /etc/shadow.orig
#cp -a /etc/shadow.orig /etc/shadow
#passwd
#echo passwd : root password not activated
${ECHO} -e "${fgyellow}passwd : root password not activated${normal}"
# sshd default Debian Jessie: no root password login
}

f10_activate_root_ssh_key() {
umask 077
mkdir /root/.ssh
#vi /root/.ssh/config
LOCAL_FILE="/root/.ssh/config"
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
#vi /root/.ssh/authorized_keys
LOCAL_FILE="/root/.ssh/authorized_keys"
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
}

f11_root_bash() {
mv /root/.bashrc /root/.bashrc.orig
cp -a /root/.bashrc.orig /root/.bashrc
#vi /root/.bashrc
LOCAL_FILE="/root/.bashrc"
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
#vi /root/.bash_logout
LOCAL_FILE="/root/.bash_logout"
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
#
if [ -e /root/.bash_history ] ; then
	mv /root/.bash_history /root/.bash_history.orig
	# we rewrite it a few lines below
	#cp -a /root/.bash_history.orig /root/.bash_history
fi
#vi /root/.bash_history
#
# rewriting /root/.bash_history is too aggressive
# despite, we do it (scripts run from outside via chroot /mnt ...)
LOCAL_FILE="/root/.bash_history"
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
## not : c02_configfile
#
LOCAL_FILE="/root/.bash_history.template"
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
# not : c02_configfile
#
# the next lines should be run before first usage of vim
# so they were duplicated in f04-install-editor
#LOCAL_FILE="/root/.vimrc"
#LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
#LOCAL_PATH="/root/.vim/"				# with /
#LP=${LOCAL_PATH} && rsync -a "${IRP}${LP}" ${LP}
}

f12_install_tools_l02_basic() {
${INSTALL} bash-completion
${INSTALL} screen
${INSTALL} tmux
echo --------------------------------------------------------------------------
${ECHO} -e "${fgcyan}prepare next install cycle${normal}"
${INSTALL} debootstrap
mkdir -p /root/bin
LOCAL_FILE="/root/bin/chrootenv.sh"
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
${INSTALL} git # git-man{a} liberror-perl{a} # recomm: patch
# git-man{a} libcurl3-gnutls{a} liberror-perl{a} libexpat1{a} libldap-2.4-2{a} librtmp1{a} libsasl2-2{a} libsasl2-modules-db{a} libssh2-1{a} perl{a} perl-modules{a}
${INSTALL} patch
echo --------------------------------------------------------------------------
# check bzip2 here, and other compressions
${INSTALL} bzip2
echo --------------------------------------------------------------------------
${INSTALL} file
${INSTALL} curl
${INSTALL} libsasl2-modules
echo --------------------------------------------------------------------------
${INSTALL} apt-file
${INSTALL} libarchive-extract-perl
${INSTALL} libcgi-pm-perl
# fmg todo 2015-02-25
# libcgi-fast-perl
${INSTALL} libmodule-build-perl
${INSTALL} libmodule-signature-perl
${INSTALL} libpod-readme-perl
${INSTALL} libsoftware-license-perl
${INSTALL} libclass-c3-xs-perl
${INSTALL} libmodule-pluggable-perl
${INSTALL} libpackage-constants-perl
${INSTALL} libpod-latex-perl
${INSTALL} libterm-ui-perl
${INSTALL} libtext-soundex-perl rename
# fmg todo 2015-02-25
#aptitude -s install iso-codes lsb-release # so war das bei Wheezy
${INSTALL} -s iso-codes lsb-release # so war das bei Wheezy
apt-file update
# test apt-rdepends
# check apt-rdepends here
${INSTALL} apt-rdepends
}

f13_timesync() {
${INSTALL} ntpdate
${INSTALL} lockfile-progs
#
### #
### TARGET_PATH="/usr/local/etc/"
### TP=${TARGET_PATH}
### LOCAL_PATH="customization"
### SOURCE_PATH="${IRP}${LOCAL_PATH}"			# no slash /
### SP=${SOURCE_PATH}
### rsync -a ${SP} ${TP}
### #
LOCAL_PATH="/usr/local/etc/customization/"		# with slash /
LP=${LOCAL_PATH} && rsync -a "${IRP}${LP}" ${LP}
#
CUSTOMIZATION_PATH_PREFIX="/usr/local"
CUSTOMIZATION_PATH="${CUSTOMIZATION_PATH_PREFIX}/etc/customization"
CUSTOMIZATION_FILE_INC="${CUSTOMIZATION_PATH}/customization.inc"
WORK_FILE=${CUSTOMIZATION_FILE_INC}
. ${WORK_FILE}
LOCAL_PATH="/usr/local/etc/${CUSTOMIZATION}/"		# with slash /
LP=${LOCAL_PATH} && rsync -a "${IRP}${LP}" ${LP}
#
#vi /usr/local/sbin/alive.sh
LOCAL_FILE="/usr/local/sbin/alive.sh"
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
#
#vi /usr/local/sbin/ntpdate.sh
LOCAL_FILE="/usr/local/sbin/ntpdate.sh"
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
#
LOCAL_FILE="/usr/local/sbin/aptitude-safe-upgrade.sh"
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
#
#echo /root/.selected_editor
# oben bei vim
#
#0-59/30 *	*	*	*	/usr/local/sbin/ntpdate.sh
#0-59/2  *	*	*	*	/usr/local/sbin/alive.sh
LOCAL_FILE="/var/spool/cron/crontabs/root"
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
if [ "${ECI}" = "y" ] ; then
	crontab -e
fi
${CHMOD} 600 ${LF}
${CHOWN} root:crontab ${LF}
}

f14_fuse() {
${INSTALL} xml-core
${INSTALL} shared-mime-info
${INSTALL} libglib2.0-data xdg-user-dirs
${INSTALL} dnsutils
${INSTALL} geoip-database
echo --------------------------------------------------------------------------
${INSTALL} sshfs
echo --------------------------------------------------------------------------
#
PACKAGE="debconf"
debconf-set-selections /opt/bootstrap/stretch/system/customized/usr/local/etc/debconf/debconf.seed--debconf.2.txt
#
# todo
PACKAGE="encfs"
#${INSTALL} encfs
mf00_install
#
echo --------------------------------------------------------------------------
#
PACKAGE="libpam-runtime"
mf02_preconfigure
#mf00_install
echo --------------------------------------------------------------------------
${INSTALL} ecryptfs-utils # keyutils{a} libecryptfs0{a} libnss3-1d libtspi1{a}
#
# fmg todo 2015-02-25
# dbus hicolor-icon-theme libgtk2.0-bin
#
PACKAGE="debconf"
debconf-set-selections /opt/bootstrap/stretch/system/customized/usr/local/etc/debconf/debconf.seed--debconf.txt
#
}

f15_who_uses_ressources() {
${INSTALL} lsof
${INSTALL} psmisc
}

f16_install_sudo() {
${INSTALL} sudo
mv /etc/sudoers /etc/sudoers.orig
cp -a /etc/sudoers.orig /etc/sudoers
}

f17_skeleton() {
echo skeleton
mkdir /etc/skel/.ssh
touch /etc/skel/.ssh/authorized_keys
#
#vi /etc/skel/.ssh/config
LOCAL_FILE="/etc/skel/.ssh/config"
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
#
# fmg todo 2015-02-25
#rsync -a /etc/skel/.vim* /root/
# nein, aber ins skel
#
mv /etc/skel/.bash_logout /etc/skel/.bash_logout.orig
cp -a /etc/skel/.bash_logout.orig /etc/skel/.bash_logout
#vi /etc/skel/.bash_logout
LOCAL_FILE="/etc/skel/.bash_logout"
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
#
mv /etc/skel/.bashrc /etc/skel/.bashrc.orig
cp -a /etc/skel/.bashrc.orig /etc/skel/.bashrc
#vi /etc/skel/.bashrc
LOCAL_FILE="/etc/skel/.bashrc"
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
}

f18_some_tools() {
${INSTALL} debconf-utils
${INSTALL} locate
if [ -x /usr/bin/updatedb ] ; then
	/usr/bin/updatedb
fi

${INSTALL} less

${INSTALL} colordiff	# doppel s.u.
${INSTALL} mc # mc-data{a}

${INSTALL} kpartx
${INSTALL} parted # libparted2{a}
${INSTALL} -s gpart testdisk
${INSTALL} -s gdisk

${INSTALL} pciutils # libpci3{a}
${INSTALL} usbutils # libusb-1.0-0{a}
${INSTALL} hdparm # # recomm: powermgmt-base
#${INSTALL} acpid # # recomm: acpi-support-base
#${INSTALL} acpi-support-base
${INSTALL} acpi
${INSTALL} acpitool
#${INSTALL} traceroute # wann kam das drauf?
${INSTALL} traceroute # nicht drauf bei Stretch
#${INSTALL} ucf # schon drauf ### ecryptfs ### todo
${INSTALL} dbus # libcap-ng0{a}

${INSTALL} sharutils
${INSTALL} sharutils-doc
${INSTALL} bc
#${INSTALL} colordiff	# doppel s.o.

${INSTALL} zip # # recomm: unzip
${INSTALL} unzip
${INSTALL} p7zip-full # p7zip{a}

${INSTALL} aspell-de aspell-en # aspell{a} dictionaries-common{a} emacsen-common{a} libaspell15{a}
#${INSTALL} myspell-de-de myspell-en-us
${INSTALL} myspell-de-de 	# no -us in Stretch
${INSTALL} myspell-en-gb # hunspell-en-gb{a}

${INSTALL} mtools
${INSTALL} dosfstools

${INSTALL} whois
${INSTALL} telnet
${INSTALL} nmap # libblas-common{a} libblas3{a} libgfortran3{a} liblinear1{a} liblua5.2-0{a} libpcap0.8{a} libquadmath0{a} # recomm: ndiff
#${INSTALL} ndiff # libpython-stdlib{a} libpython2.7-minimal{a} libpython2.7-stdlib{a} libxslt1.1{a} mime-support{a} python{a} python-lxml{a} python-minimal{a} python2.7{a} python2.7-minimal{a}
${INSTALL} mime-support # # recomm: xz-utils
${INSTALL} xz-utils
${INSTALL} python-minimal # libpython2.7-minimal{a} python2.7-minimal{a} # recomm: libpython2.7-stdlib python python2.7
${INSTALL} python # libpython-stdlib{a} libpython2.7-stdlib{a} python2.7{a}
${INSTALL} ndiff # libxslt1.1{a} python-lxml{a}
${INSTALL} iftop
${INSTALL} htop
# iotop
${INSTALL} arptables
${INSTALL} ebtables
${INSTALL} ethtool
${INSTALL} hping3 # libtcl8.6{a}

#${INSTALL} lynx # lynx-cur{a}
${INSTALL} lynx # lynx-common{a}
${INSTALL} links
#${INSTALL} links2 # libdirectfb-1.2-9{a}
#${INSTALL} links2 # fontconfig{a} fontconfig-config{a} fonts-dejavu-core{a} libcairo2{a} libcroco3{a} libdatrie1{a} libdirectfb-1.2-9{a} libfontconfig1{a} libgdk-pixbuf2.0-0{a} libgdk-pixbuf2.0-common{a} libgomp1{a} libgraphite2-3{a} libharfbuzz0b{a} libjbig0{a} libjpeg62-turbo{a} libpango-1.0-0{a} libpangocairo-1.0-0{a} libpangoft2-1.0-0{a} libpixman-1-0{a} librsvg2-2{a} libthai-data{a} libthai0{a} libtiff5{a} libxcb-render0{a} libxcb-shm0{a} libxrender1{a} # recomm: eterm gnome-terminal konsole kterm librsvg2-common lilyterm lxterminal mate-terminal mlterm mlterm-tiny mrxvt mrxvt-cjk mrxvt-mini pterm qterminal rxvt rxvt-ml rxvt-unicode rxvt-unicode-256color rxvt-unicode-lite sakura stterm terminator termit vala-terminal xfce4-terminal xiterm+thai xterm xvt
#${INSTALL} elinks # elinks-data{a} libfsplib0{a} libperl5.20{a} libtre5{a}
${INSTALL} elinks # elinks-data{a} libfsplib0{a} liblua5.1-0{a} libtre5{a}
${INSTALL} w3m # libgc1c2{a}

#${INSTALL} git # git-man{a} liberror-perl{a} # recomm: patch
#${INSTALL} patch
${INSTALL} make

${INSTALL} molly-guard

# https://www.digitalocean.com/community/tutorials/how-to-protect-ssh-with-fail2ban-on-debian-7
${INSTALL} fail2ban # # recomm: python-pyinotify
${INSTALL} python-pyinotify

${INSTALL} uuid-runtime

#${INSTALL} cpp # cpp-4.9{a} libcloog-isl4{a} libisl10{a} libmpc3{a} libmpfr4{a}

# luit
#${INSTALL} x11.utils # libfontenc1{a} libxaw7{a} libxcb-shape0{a} libxmu6{a} libxpm4{a} libxt6{a} libxv1{a} libxxf86dga1{a}
#${INSTALL} x11-utils # libfontenc1{a} libxaw7{a} libxcb-shape0{a} libxmu6{a} libxpm4{a} libxt6{a} libxv1{a} libxxf86dga1{a}

${INSTALL} net-tools	# old legacy ifconfig

#${INSTALL} .
#${INSTALL} .
#${INSTALL} .
#${INSTALL} .
#${INSTALL} .
}


stage_00_01_pre_user() {
echo
echo --------------------------------------------------------------------------
echo 1st 2015-10-05 16:09 chroot
echo --------------------------------------------------------------------------
c00_check_customization
c01_check_edit
echo --------------------------------------------------------------------------
#f0-safe-orig-config-files
f00_safe_orig_config_file_apt_sources
echo --------------------------------------------------------------------------
f01_prepare_apt
echo --------------------------------------------------------------------------
f02_use_aptitude
echo --------------------------------------------------------------------------
f03_prepare_environment
echo --------------------------------------------------------------------------
f04_install_editor
echo --------------------------------------------------------------------------
f05_reconfigure_apt_sources
echo --------------------------------------------------------------------------
f06_install_tools_l01_elementary
echo --------------------------------------------------------------------------
f07_safe_orig_config_files_elementary
echo --------------------------------------------------------------------------
f08_install_ssh
echo --------------------------------------------------------------------------
f09_activate_root_password
echo --------------------------------------------------------------------------
f10_activate_root_ssh_key
echo --------------------------------------------------------------------------
f11_root_bash
echo --------------------------------------------------------------------------
f12_install_tools_l02_basic
echo --------------------------------------------------------------------------
f13_timesync
echo --------------------------------------------------------------------------
f14_fuse
echo --------------------------------------------------------------------------
f15_who_uses_ressources
echo --------------------------------------------------------------------------
f16_install_sudo
echo --------------------------------------------------------------------------
f17_skeleton
echo --------------------------------------------------------------------------
# check this if it belongs to stage.00.01-pre-user
#f18_some_tools
echo --------------------------------------------------------------------------
echo stage.00.01-pre-user
echo --------------------------------------------------------------------------
echo 'python?'
echo --------------------------------------------------------------------------
echo
${ECHO} -e "${fgred}you might want to set a root password now${normal}"
echo
echo --------------------------------------------------------------------------
echo
}


f_extra_01_kernel() {
ln -s /proc/mounts /etc/mtab
${INSTALL} linux-image-amd64 # libuuid-perl{a} linux-base{a} linux-image-3.16.0-4-amd64{a} # recomm: firmware-linux-free irqbalance
${INSTALL} firmware-linux-free
}

f_extra_02_bootloader_grub2() {
${INSTALL} grub2 # grub-common{a} grub-pc{a} grub-pc-bin{a} grub2-common{a} # recomm: os-prober
}


stage_00_02_kernel() {
echo
echo --------------------------------------------------------------------------
f_extra_01_kernel
echo --------------------------------------------------------------------------
echo stage.00.02-kernel
echo --------------------------------------------------------------------------
echo
}

stage_00_03_bootloader() {
echo
echo --------------------------------------------------------------------------
# this is interactive
if [ "${ECI}" = "y" ] ; then
	f_extra_02_bootloader_grub2
fi
echo --------------------------------------------------------------------------
echo stage.00.03-bootloader
echo --------------------------------------------------------------------------
echo
}

stage_00_04_acpi() {
echo
echo --------------------------------------------------------------------------
${INSTALL} acpid # # recomm: acpi-support-base
${INSTALL} acpi-support-base
echo --------------------------------------------------------------------------
echo stage.00.04-acpi
echo --------------------------------------------------------------------------
echo
}

# mta here
f_add_mail() {
#
# default user sysadmin,
# ${DEFUSER}
ID=1000 ; u=sysadmin ; g=${u} ; addgroup --gid $ID $g ; adduser --gid $ID --uid $ID --disabled-password --gecos $u,13,23,42,666 $u
#
GROUPLIST_COMPLETE="adm audio cdrom dialout disk floppy kvm libvirt plugdev staff sudo video"
G=${GROUPLIST_COMPLETE}
for g in `echo ${G}` ; do echo -e "${g} : " ; grep ^${g} /etc/group ; echo ; done
#
GROUPLIST="adm audio cdrom dialout disk floppy plugdev staff sudo video"
G=${GROUPLIST}
for g in `echo ${G}` ; do echo -e "${g} : " ; grep ^${g} /etc/group ; echo ; done
#
for g in ${GROUPLIST} ; do adduser ${u} ${g} ; done
#
#${INSTALL} postfix
PACKAGE="postfix"
mf00_install
${INSTALL} procmail
mv /etc/postfix/main.cf /etc/postfix/main.cf.orig
LOCAL_FILE="/etc/postfix/main.cf"
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
#c02_configfile
#
mv /etc/aliases /etc/aliases.orig
LOCAL_FILE="/etc/aliases"
#LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
c02_configfile
${POSTALIAS} /etc/aliases
#
${INSTALL} at
${INSTALL} mutt # libtokyocabinet9{a}
${INSTALL} fetchmail
${INSTALL} getmail4
${INSTALL} maildrop # courier-authlib{a} expect{a} libltdl7{a} tcl-expect{a} # recomm: tcl8.6 tk8.6
${INSTALL} tcl8.6 tk8.6 # ... # recomm: ...
${INSTALL} lbdb # libvformat0{a}
#${INSTALL} .
#
}

# rkhunter unhide here
## http://www.cyberciti.biz/tips/linux-unix-windows-find-hidden-processes-tcp-udp-ports.html

f_add_apache_munin_php5_phpsysinfo() {
${INSTALL} apache2 # apache2-bin{a} apache2-data{a} apache2-utils{a} libapr1{a} libaprutil1{a} libaprutil1-dbd-sqlite3{a} libaprutil1-ldap{a} liblua5.1-0{a}
${INSTALL} munin # fonts-dejavu{a} fonts-dejavu-extra{a} libdate-manip-perl{a} libdbi1{a} libfile-copy-recursive-perl{a} libhtml-template-perl{a} libio-socket-inet6-perl{a} liblog-log4perl-perl{a} librrd4{a} librrds-perl{a} libsocket6-perl{a} liburi-perl{a} munin-common{a} rrdtool{a} # recomm: libcgi-fast-perl libipc-shareable-perl liblog-dispatch-perl munin-doc munin-node ### 15 newly installed
${INSTALL} libcgi-fast-perl # libfcgi-perl{a}
${INSTALL} libipc-shareable-perl 
${INSTALL} liblog-dispatch-perl # libdevel-globaldestruction-perl{a} libdist-checkconflicts-perl{a} libmodule-implementation-perl{a} libmodule-runtime-perl{a} libparams-classify-perl{a} libparams-validate-perl{a} libsub-exporter-progressive-perl{a} libtry-tiny-perl{a} # recomm: libmail-sendmail-perl libmailtools-perl libmime-lite-perl
${INSTALL} libmail-sendmail-perl # libsys-hostname-long-perl{a}
${INSTALL} libmailtools-perl # libio-socket-ssl-perl{a} libnet-smtp-ssl-perl{a} libnet-ssleay-perl{a} libtimedate-perl{a} # recomm: libauthen-sasl-perl
${INSTALL} libauthen-sasl-perl
${INSTALL} libmime-lite-perl # libemail-date-format-perl{a} # recomm: libmime-types-perl
${INSTALL} libmime-types-perl
${INSTALL} munin-doc 
${INSTALL} munin-node # gawk{a} libio-multiplex-perl{a} libnet-cidr-perl{a} libnet-server-perl{a} libsigsegv2{a} munin-plugins-core{a} # recomm: libnet-snmp-perl munin-plugins-extra
${INSTALL} libnet-snmp-perl
${INSTALL} munin-plugins-extra
${INSTALL} php5 # libapache2-mod-php5{a} libonig2{a} libqdbm14{a} php5-cli{a} php5-common{a} php5-json{a} # recomm: php5-readline
${INSTALL} php5-readline
${INSTALL} phpsysinfo # php5-xsl{a}
${INSTALL} apachetop # gamin{a} libadns1{a} libgamin0{a}
}

# https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-monit
f_add_monit() {
${INSTALL} monit
}

stage_00_xy_mta_web_monitoring() {
#
#f18_some_tools
f_add_mail
f_add_apache_munin_php5_phpsysinfo
f_add_monit
#
}

# ----------------------------------------------------------------------

special_stuff(){
${INSTALL} firmware-bnx2					### from non-free
${INSTALL} intel-microcode # iucode-tool{a}			### from non-free
}

# ----------------------------------------------------------------------

# main programm

stage_00_01_pre_user
stage_00_02_kernel
#stage_00_03_bootloader
stage_00_04_acpi
f18_some_tools
#stage_00_xy_mta_web_monitoring

# depending on special hardware you should install some non-free stuff
#special_stuff

# EOF
