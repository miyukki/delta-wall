gulp      = require 'gulp'
haml      = require 'gulp-ruby-haml'
sass      = require 'gulp-sass'
coffee    = require 'gulp-coffee'
plumber   = require 'gulp-plumber'
webserver = require 'gulp-webserver'

gulp.task('build-haml', ->
  gulp.src('src/**/*.haml')
    .pipe(plumber())
    .pipe(haml())
    .pipe(gulp.dest('dist/'))
)

gulp.task('build-sass', ->
  gulp.src('src/sass/**/*.sass')
    .pipe(plumber())
    .pipe(sass())
    .pipe(gulp.dest('dist/css/'))
)

gulp.task('build-coffee', ->
  gulp.src('src/coffee/**/*.coffee')
    .pipe(plumber())
    .pipe(coffee())
    .pipe(gulp.dest('dist/js/'))
)

gulp.task('build',  ['build-haml', 'build-sass', 'build-coffee'])

gulp.task('watch', ->
  gulp.watch('src/**/*.haml', ['build-haml'])
  gulp.watch('src/sass/**/*.sass', ['build-sass'])
  gulp.watch('src/coffee/**/*.coffee', ['build-coffee'])
)

gulp.task('webserver', ->
  gulp.src('dist')
    .pipe(webserver(
      host: '127.0.0.1'
      livereload: true
    ))
)

gulp.task('default', ['build', 'watch', 'webserver'])

# gulp.task 'clean', (callback) ->
#   del 'build', callback
#
# gulp.task 'coffee', ->
#   gulp.src 'src/*.coffee'
#     .pipe coffee(bare: true)
#     .pipe gulp.dest('build')
#
# gulp.task 'copySource', ->
#   dependencies = (name for name, version of pkg.dependencies)
#   gulp.src "node_modules/{#{dependencies.join(',')}}/**"
#     .pipe gulp.dest('build/node_modules')
#
# gulp.task 'copyConfig', ->
#   gulp.src 'config.yml'
#     .pipe gulp.dest('build/')
#
# gulp.task 'zip', ['coffee', 'copySource', 'copyConfig'], ->
#   gulp.src 'build/**'
#     .pipe zip('lambda.zip')
#     .pipe gulp.dest('dist')
#
# gulp.task 'build', ->
#   runSequence 'clean', 'zip'
