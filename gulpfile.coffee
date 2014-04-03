gulp = require 'gulp'
livereload = require 'gulp-livereload'
jade = require 'gulp-jade'
browserify = require 'gulp-browserify'
rename = require 'gulp-rename'
stringToJs = require 'string-to-js'
gutil = require 'gulp-util'

gulp.task 'default'

gulp.task 'jade', ->
    gulp.src 'layout/**'
        .pipe jade({
            pretty: true
            })
        .pipe(gulp.dest 'build')

gulp.task 'coffee', ->
    gulp.src 'coffee/app.coffee', {read: false}
        .pipe(browserify {
            transform: ['coffeeify']
            extensions: ['.coffee']
            })
        .pipe(rename 'app.js')
        .pipe(gulp.dest 'build/js')

gulp.task 'template', ->
    fs = require 'fs'
    es = require 'event-stream'
    gulp.src 'template/**'
        .pipe es.through (file)->
            if file.isNull()
                this.emit 'data', file
                return
            if file.isStream()
                this.emit 'error', new Error 'Streaming not supported'
                return
            data = stringToJs file.contents.toString('utf8')
            dest = gutil.replaceExtension file.path, '.js'
            file.contents = new Buffer(data)
            file.path = dest
            this.emit 'data', file
        .pipe(gulp.dest 'build/template')

gulp.task 'staticserver', ->
    staticS = require 'node-static'
    server = new staticS.Server 'build'
    port = 8080

    require('http').createServer (request, response) ->
        request.addListener 'end', ->
            server.serve request, response
        .resume()
    .listen port

gulp.task 'watch', ['jade', 'staticserver'], ->
    server = livereload()
    gulp.watch 'layout/**', ['jade']
    gulp.watch 'coffee/**', ['coffee']
    gulp.watch('build/**').on 'change', (file) ->
        server.changed file.path
