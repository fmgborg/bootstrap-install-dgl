#
#!/bin/bash

# http://jpetazzo.github.io/2013/10/06/policy-rc-d-do-not-start-services-automatically/

PATH="${PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

RL=`runlevel`
if [ "${RL}" = "unknown" ] ; then
	#echo 101 && exit 101
	exit 101
else
	#echo 0 && exit 0
	exit 0
fi

# EOF
