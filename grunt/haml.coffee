module.exports = (grunt) ->
	two:
		files: 
			grunt.file.expandMapping(['public/haml/*.haml','public/haml/shared/*.haml'], './',
          rename: (base, path) ->
            base + path.replace(/\/haml\//, '/html/').replace(/\.haml$/, '.html'))
		options:
			language: 'ruby'
