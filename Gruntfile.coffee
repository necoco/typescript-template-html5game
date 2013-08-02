module.exports = (grunt)->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    typescript:
      compile:
        src: ['d.ts/**/*.d.ts', 'bower_components/**/*.d.ts', 'src/**/*.ts']
        dest: 'out/main/main.js'
        options:
          module: 'commonjs'
          target: 'es5'
          sourcemap: true
          declaration: true
      test:
        src: ['d.ts/**/*.d.ts', 'out/**/*.d.ts', 'bower_components/**/*.d.ts', 'test/**/*.ts']
        dest: 'out/test/main.test.js'
        options:
          module: 'commonjs'
          target: 'es5'

    uglify:
      min:
        files:
          'bin/main.min.js': ['out/main/main.js']

    connect:
      preview:
        options:
          port: 9000
          livereload: true
          middleware: (connect, options)->
            [
              connect.static('pub')
              connect.static('src')
            ]

    copy:
      pub:
        files:[
            expand: true
            cwd: 'out/main'
            src: ['**']
            dest: 'pub/js/out'
          ,
            expand: true
            cwd: 'src'
            src: ['**']
            dest: 'pub/src'
          ,
            expand: true
            cwd: 'res'
            src: '**'
            dest: 'pub'
          ,
            expand: true
            cwd: 'bower_components'
            src: '*.js'
            dest: 'pub/js'
        ]

    watch:
      scripts:
        files: ['src/**/*.ts', 'res/**/*']
        tasks: ['compile', 'test', 'copy']
        options:
          spawn: false
          livereload: true

    jasmine:
      src: 'out/test/main.test.js'

    clean:
      all: ['pub', 'out']


  grunt.loadNpmTasks 'grunt-typescript'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-jasmine'
  grunt.loadNpmTasks 'grunt-contrib-clean'

  grunt.registerTask 'compile', ['typescript:compile']
  grunt.registerTask 'default', ['build', 'test', 'copy']
  grunt.registerTask 'build', ['compile', 'uglify']
  grunt.registerTask 'preview', ['build', 'test', 'copy', 'connect', 'watch']
  grunt.registerTask 'test', ['compile', 'typescript:test', 'jasmine']