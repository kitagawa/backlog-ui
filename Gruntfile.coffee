module.exports = (grunt) ->
  # タスクをすべて読み込み
  require('load-grunt-config')(grunt)

  #タスク登録
  grunt.registerTask 'default', ['connect',"watch"]