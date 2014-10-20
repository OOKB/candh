fs = require 'fs-extra'
path = require 'path'
exec = require('child_process').exec

_ = require 'lodash'
gulp = require 'gulp'
browserSync = require 'browser-sync'
browserify = require 'browserify'
watchify = require 'watchify'
coffeeify = require 'coffeeify'
react = require 'react'

source = require 'vinyl-source-stream'

less = require 'gulp-less'
zopfli = require 'gulp-zopfli'
rename = require 'gulp-rename'
yaml = require 'gulp-yaml'
markdown = require 'gulp-markdown-to-json'
runSequence = require 'run-sequence'
clean = require 'gulp-clean'

cf = require './gulp/cape-cf'

gulp.task "default", ['compile', 'templates', 'browser-sync', 'static', 'styles', 'projects', 'content', 'files'], ->
  gulp.watch './static/**', ['static']
  gulp.watch './styles/*.less', ["styles"]
  gulp.watch './content/**/*.yaml', ['projects']
  gulp.watch './content/**/*.md', ['content']
  gulp.watch './app/**/*.*', ['templates']
  return

gulp.task "browser-sync", ->
  browserSync.init "public/**",
    server:
      baseDir: "public" # Change this to your web root dir
    injectChanges: false
    logConnections: true
  return

gulp.task 'data', ->
  gulp.src './content/**/*.yaml'
    .pipe yaml()
    .pipe gulp.dest('./app/data/')

gulp.task 'content', ->
  gulp.src './content/**/*.md'
    .pipe markdown()
    .pipe gulp.dest('./app/data/')

gulp.task 'projects', ['data'], (cb) ->
  pre = './app/data/projects/'
  files = fs.readJsonSync './app/data/files.json'
  getDirs = (pre) ->
    fs.readdirSync(pre).filter (file) ->
      fs.statSync(pre+file).isDirectory()

  getData = ->
    projects = getDirs(pre).map (dir) ->
      proj = fs.readJsonSync pre+dir+'/index.json'
      proj.key = dir
      images = _.pluck files.files[dir].files, 'path'
      proj.images = images
      proj.mainImg = _.first images
      return proj
  fs.outputJson pre+'index.json', getData(), ->
    cb()
  return

gulp.task 'files', (cb) ->
  container = 'www.candhrestoration.com'
  marker = ''
  cf.container_info container, marker, (err, result) ->
    if err then throw err
    fs.outputJson './app/data/files.json', result, ->
      cb()
  return

gulp.task 'templates', ->
  exec('coffee compile.coffee')

gulp.task 'compile', ->
  opts = watchify.args
  opts.extensions = ['.coffee', '.json']
  w = watchify(browserify('./app/index.coffee', opts))
  #w.transform coffeeify
  bundle = () ->
    w.bundle()
      .pipe(source('app.js'))
      .pipe(gulp.dest('./public/'))
  w.on('update', bundle)
  bundle()
  return

gulp.task 'styles', ->
  gulp.src(["styles/app.less", 'styles/print.less', 'styles/iefix.less', 'styles/static.less', 'styles/whenloading.less'])
    .pipe less(paths: [path.join(__dirname, "less", "includes")])
    .pipe gulp.dest("./public")

gulp.task 'static', ->
  gulp.src('./static/**/*.*')
    .pipe gulp.dest('./public/')

gulp.task 'proj-img', ->
  gulp.src('./content/**/main.jpg')
    .pipe gm((gmfile) -> gmfile.scale(200, 200, '^').gravity('Center').crop(200, 200))
    .pipe gulp.dest('./public/')

# - - - - prod - - - -


gulp.task 'prod', ->
  # Clean out the prod and public directory.
  runSequence ['prod_clean', 'public_clean'],
    # Run all the tasks except compile and browser-sync to update the public directory.
    ['templates', 'static', 'styles', 'projects', 'content', 'files']
    # Copy the public dir to the prod directory
    ['copy_public', 'prod_compile']

  return

# Remove contents from prod directory.
gulp.task 'prod_clean', ->
  gulp.src('./prod', read: false)
    .pipe(clean())

# Remove contents from public directory.
gulp.task 'public_clean', ->
  gulp.src('./public', read: false)
    .pipe(clean())

gulp.task 'copy_public', ->
  gulp.src('./public/**/*.*')
    .pipe gulp.dest('./prod/')

gulp.task 'prod_compile', (cb) ->
  # Javascript bundle
  opts =
    debug: true
    extensions: ['.coffee', '.json']
  bundler = browserify opts
  #bundler.transform coffeeify
  bundler.add('./app/index.coffee')
  bundler.plugin 'minifyify',
    map: 'script.map.json'
    output: './prod/script.map.json'
  bundler.bundle debug: true
    .pipe(source('app.js'))
    .pipe(gulp.dest('./prod/'))
    .on('end', cb)
  return

gulp.task 'prod_compress', ->
  gulp.src("./prod/*.{js,css,html,json}")
    .pipe(zopfli())
    .pipe(gulp.dest("./prod"))
