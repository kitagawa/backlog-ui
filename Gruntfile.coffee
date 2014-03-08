module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-haml'

  grunt.initConfig
    #hamlコンパイル
    haml:
      one:
        files:
          'public/html/projects.html' : 'public/haml/projects.haml'
          'public/html/versions.html' : 'public/haml/versions.haml'
        options:
          language: "ruby"
    #監視設定
    watch:
      files:['public/haml/*.haml']
      tasks:['haml']
  #タスク登録
  grunt.registerTask 'default', ['haml']