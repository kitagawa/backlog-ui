module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-haml'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-compass'
  grunt.loadNpmTasks 'grunt-contrib-jasmine'

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

    #cofeescriptコンパイル
    coffee:
      compile:
        files: [
          expand: true
          src: ['public/coffee/*.coffee']
          dest: './'
          ext: '.js'
        ]
        options: 
          bare: true

    # Compass
    compass:
      dist:
        options:
          config: 'config.rb'

    #jasmine　ユニットテスト
    jasmine:
      src: ['public/js/jquery.min.js',
      'public/js/angular.min.js',
      'public/js/angular-mocks.js',
      'public/js/*.js',
      'public/coffee/*.js']
      options:
        specs: 'spec/javascripts/*Spec.js'
        helpers: 'spec/helpers/*Helper.js'

    #監視設定
    watch:
      coffee:
        files: ['public/coffee/*.coffee']
        tasks: ['coffee']
      sass:
        files: ['public/sass/*.scss'],
        tasks: ['compass']
      haml:
        files:['public/haml/*.haml']
        tasks:['haml']
        options:
          livereload: true #変更があればリロードする
      jasmine:
        files: ['public/coffee/*.js','spec/javascripts/*.js']
        tasks: ['jasmine']

  #タスク登録
  grunt.registerTask 'default', ['connect',"watch"]