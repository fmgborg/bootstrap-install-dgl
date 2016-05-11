#

	SSLProxyEngine		On
	SSLProxyVerify		None 
	SSLProxyCheckPeerCN	Off
	SSLProxyCheckPeerName	Off

	Define PROTO https

	ProxyPreserveHost	On
	ProxyPass		/	${PROTO}://localhost:8432/
	ProxyPassReverse	/	${PROTO}://localhost:8432/

#
