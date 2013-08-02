module.exports = (grunt)->
  reply = null

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    typescript:
      compile:
        src: ['src/**/*.ts', 'd.ts/**/*.d.ts', 'bower_components/**/*.d.ts']
        dest: 'out/main.js'
        options:
          module: 'commonjs'
          target: 'es5'
          sourcemap: true
          declaration: true
      test:
        src: ['test/**/*.ts', 'd.ts/**/*.d.ts', 'out/**/*.d.ts', 'bower_components/**/*.d.ts']
        dest: 'out/main.test.js'
        options:
          module: 'commonjs'
          target: 'es5'

    uglify:
      min:
        files:
          'bin/main.min.js': ['out/main.js']

    connect:
      preview:
        options:
          port: 9000
          base: 'pub'
          keepalive: true
          middleware: (connect, options)->
            [
              connect.static(options.base)
              (req, res)->
                if req.url == '/polling'
                  reply = res
            ]

    copy:
      pub:
        files:[
            expand: true
            cwd: 'out'
            src: '**'
            dest: 'pub/js'
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
        files: ['src/**/*.ts']
        tasks: ['compile', 'notify']
        options:
          spawn: false

    jasmine:
      src: 'out/main.test.js'

  grunt.loadNpmTasks 'grunt-typescript'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-jasmine'

  grunt.registerTask 'compile', ['typescript:compile']
  grunt.registerTask 'default', ['compile']
  grunt.registerTask 'build', ['compile', 'uglify']
  grunt.registerTask 'preview', ['build', 'watch', 'copy', 'connect']
  grunt.registerTask 'test', ['compile', 'typescript:test', 'jasmine']
  grunt.registerTask 'notify', ()->
    reply.end("refesh") if reply