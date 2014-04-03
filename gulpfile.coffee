gulp = require 'gulp'
livereload = require 'gulp-livereload'
jade = require 'gulp-jade'
browserify = require 'gulp-browserify'
rename = require 'gulp-rename'
fileToJs = require 'gulp-file-to-js'
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
    gulp.src 'template/**'
        .pipe(fileToJs())
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
    gulp.watch 'template/**', ['template', 'coffee']
    gulp.watch('build/**').on 'change', (file) ->
        server.changed file.path
