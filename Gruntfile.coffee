module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-haml'
  grunt.loadNpmTasks 'grunt-contrib-connect';
  
  grunt.initConfig
    #hamlコンパイル
    haml:
      one:
        files:
          'public/html/projects.html' : 'public/haml/projects.haml'
          'public/html/versions.html' : 'public/haml/versions.haml'
        options:
          language: "ruby"

    #grunt-contrib-connectの設定(Webサーバの設定)
    connect:
      site: {}

    #監視設定
    watch:
      files:['public/haml/*.haml']
      tasks:['haml']
      options:
        livereload: true #変更があればリロードする

  #タスク登録
  grunt.registerTask 'default', ['connect',"watch"]