#

# if [ "$SHLVL" = 1 ]; then
#     [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
# fi

cd ~
TIMESTAMP=`date "+%Y%m%d-%H%M%S"`
BACKUPFILE="backup--${TIMESTAMP}".`hostname`.bash_history
#BACKUPPATH="~" # this is wrong, ~ not "~" and better $HOME
BACKUPPATH="${HOME}/backup/`hostname`/bash_history"
# create it
if [ ! -d ${BACKUPPATH} ] ; then
        mkdir -p ${BACKUPPATH}
fi
BACKUPNAME=${BACKUPPATH}/${BACKUPFILE}
cp -a ~/.bash_history ${BACKUPNAME}
#cp -a ~/.bash_history ${BACKUPFILE}
echo
#clear
echo -e "\t"${TIMESTAMP}
echo
#clear
date
echo logout

# EOF
