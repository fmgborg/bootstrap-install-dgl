#

	# Alias /TODO/phpsysinfo /usr/share/phpsysinfo
	<Directory /usr/share/phpsysinfo>
		AuthUserFile /usr/local/etc/phpsysinfo/htpasswd
		AuthName "admin view phpsysinfo"
		AuthType Basic
		Require valid-user
		Options FollowSymLinks SymLinksIfOwnerMatch
	</Directory>

#
