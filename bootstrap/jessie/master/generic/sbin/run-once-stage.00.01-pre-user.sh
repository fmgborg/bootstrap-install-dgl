#!/bin/bash

# multipurpose installation script
# author:			Frank Guthausen
# date:				2008-2015
# this structure:		2015-10-05
# install + reconfiguration:	2016-05-05
# last modification:		2016-05-05

PATH="${PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# Change this flag to edit some configuration files interactively or not.
# safety lock
#EDIT_CONFIGURATION_INTERACTIVE="n"
#EDIT_CONFIGURATION_INTERACTIVE="y"
EDIT_CONFIGURATION_INTERACTIVE="undefined"
ECI=${EDIT_CONFIGURATION_INTERACTIVE}

IPv4_PREFERRED="y"
#IPv4_PREFERRED="n"

# Change INSTALL_RESSOURCES_PATH to your needs, but changes will appear
# in different locations. Default is having bootstrap/ in /opt/ as shown
# here.
# 
#INSTALL_RESSOURCES_PATH="/opt/install/system"
#INSTALL_RESSOURCES_PATH="/opt/bootstrap/jessie/system"
INSTALL_RESSOURCES_PATH="/opt/bootstrap/jessie/system/customized"
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
	${DEBCONF_SET_SELECTIONS} ${DPFILE}
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
	${DEBCONF_SET_SELECTIONS} ${DPFILE}
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
aptitude safe-upgrade
}

f03_prepare_environment() {
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
LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
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
aptitude safe-upgrade
${ECHO} -e "${fggreen}security upgrades done${normal}"
}

f06_install_tools_l01_elementary() {
#
PACKAGE="cryptsetup"
#${INSTALL} cryptsetup
mf00_install
#
${INSTALL} busybox
${INSTALL} initramfs-tools
#
PACKAGE="keyboard-configuration"
mf02_preconfigure
${INSTALL} kbd
#
PACKAGE="console-data"
#${INSTALL} console-data
mf00_install
#
${INSTALL} console-common
#
PACKAGE="console-setup"
#${INSTALL} console-setup
mf00_install
#dpkg-reconfigure console-setup
mf01_reconfigure
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
FILELIST="fstab crypttab hosts hostname network/interfaces shadow rc.local inittab issue issue.net motd"
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
echo passwd : root password not activated
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
	cp -a /root/.bash_history.orig /root/.bash_history
fi
#vi /root/.bash_history
#
# rewriting /root/.bash_history is too aggressive
#LOCAL_FILE="/root/.bash_history"
#LF=${LOCAL_FILE} && rsync -a "${IRP}${LF}" ${LF}
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
${INSTALL} debootstrap
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
}

f14_fuse() {
${INSTALL} xml-core
${INSTALL} shared-mime-info
${INSTALL} libglib2.0-data xdg-user-dirs
${INSTALL} dnsutils
${INSTALL} geoip-database
echo --------------------------------------------------------------------------
${INSTALL} sshfs
#
# todo
PACKAGE="encfs"
#${INSTALL} encfs
mf00_install
#
PACKAGE="libpam-runtime"
mf02_preconfigure
${INSTALL} ecryptfs-utils # keyutils{a} libecryptfs0{a} libnss3-1d libtspi1{a}
#
# fmg todo 2015-02-25
# dbus hicolor-icon-theme libgtk2.0-bin
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
${INSTALL} debconf-utils
echo --------------------------------------------------------------------------
echo stage.00.01-pre-user
echo --------------------------------------------------------------------------
echo --------------------------------------------------------------------------
echo 'python?'
echo --------------------------------------------------------------------------
echo
${ECHO} -e "${fgred}you might want to set a root password now${normal}"
echo
echo --------------------------------------------------------------------------
echo
}

stage_00_01_pre_user

# EOF
