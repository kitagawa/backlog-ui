module.exports =
  compile:
    files: [
      expand: true
      cwd: 'public/coffee/'
      src: ['*.coffee']
      dest: 'public/javascripts/'
      ext: '.js'
    ]
    options: 
      bare: true
