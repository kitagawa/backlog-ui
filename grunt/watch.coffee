module.exports =
    #監視設定
  coffee:
    files: ['public/coffee/*.coffee']
    tasks: ['coffee']
    options:
      livereload: true
  sass:
    files: ['public/sass/*.scss']
    tasks: ['compass']
    options:
      livereload: true
  haml:
    files: ['public/haml/*.haml', 'public/haml/shared/*.haml']
    tasks: ['haml']
    options:
      livereload: true
  jasmine:
    files: ['public/js/*.js','spec/javascripts/*.js']
    tasks: ['jasmine']
    options:
      livereload: false

