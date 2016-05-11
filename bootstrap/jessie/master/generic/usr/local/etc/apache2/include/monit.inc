#

	SSLProxyEngine		On
	SSLProxyVerify		None 
	SSLProxyCheckPeerCN	Off
	SSLProxyCheckPeerName	Off

	Define PROTO https
	Define PORT 2812

	ProxyPreserveHost	On
	ProxyPass		/monit/		${PROTO}://localhost:${PORT}/
	ProxyPassReverse	/monit/		${PROTO}://localhost:${PORT}/
	<Location /monit>
		AuthUserFile /usr/local/etc/monit/htpasswd
		AuthName "admin view monit"
		AuthType Basic
		Require valid-user
		Options FollowSymLinks SymLinksIfOwnerMatch
	</Location>


#
