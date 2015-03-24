module.exports =
  compile:
    options:
      join: true
      bare: true
    files:
      'public/js/app.js': [
        'public/coffee/app.coffee'
        'public/coffee/*.coffee'
      ]