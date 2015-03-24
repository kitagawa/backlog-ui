proxySnippet = require('grunt-connect-proxy/lib/utils').proxyRequest;

module.exports =
	proxies: [
	  context: '/'
	  host: 'localhost'
	  port: 9393
	  https: false
	  changeOrigin: false
  ]
  options:
    port: 9000
    # Change this to '0.0.0.0' to access the server from outside.
    hostname: 'localhost'
    livereload: 35729
  livereload:
    options: 
      open: false,
      base: [
        '/'
      ]
      middleware: (connect) ->
        [
        	proxySnippet,
          connect.static(require('path').resolve('public'))
        ];
