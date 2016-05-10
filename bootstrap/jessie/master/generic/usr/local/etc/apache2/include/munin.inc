#

	Alias /TODO/munin /var/cache/munin/www
	<Directory /var/cache/munin/www>
		AuthUserFile /usr/local/etc/munin/htpasswd
		AuthName "admin view munin"
		AuthType Basic
		Require valid-user
		Options FollowSymLinks SymLinksIfOwnerMatch
	</Directory>

#
