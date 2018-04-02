# ~/.bash_logout: executed by bash(1) when login shell exits.

# when leaving the console clear the screen to increase privacy

if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi
# fmg
cd ~
TIMESTAMP=`date "+%Y%m%d-%H%M%S"`
THISHOST=`hostname`
BACKUPFILE="backup--${TIMESTAMP}".${THISHOST}.bash_history
BACKUPPATH="${HOME}/backup/${THISHOST}/bash_history"
# create it
if [ ! -d ${BACKUPPATH} ] ; then
        mkdir -p ${BACKUPPATH}
fi
BACKUPNAME=${BACKUPPATH}/${BACKUPFILE}
cp -a ~/.bash_history ${BACKUPNAME}
echo
echo -e "\t"${TIMESTAMP}
echo
date
echo logout

# EOF
