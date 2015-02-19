module.exports =
    #監視設定
  coffee:
    files: ['public/coffee/*.coffee']
    tasks: ['coffee']
  sass:
    files: ['public/sass/*.scss']
    tasks: ['compass']
  haml:
    files: ['public/haml/*.haml', 'public/haml/shared/*.haml']
    tasks: ['haml']
    options:
      livereload: true #変更があればリロードする
  jasmine:
    files: ['public/coffee/*.coffee','spec/javascripts/*.js']
    tasks: ['jasmine']
