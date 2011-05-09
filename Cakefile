fs = require("fs")
{exec} = require("child_process")

task "build", "builds the project", (options) ->

  files = [
    "ahoy"
    "matchers"
    "hosts"
    "cookie"
    "uri"
    "json"
  ]

  file_str = ""
  for file in files
    file_str += "src/#{file}.coffee "

  run "coffee -o dist -l -j ahoy.js -c #{file_str}", (error, stdout, stderr) ->
    console.log "Build successful" unless error

task "spec", "runs tests", (options) ->
  run "jasmine-node --coffee spec"

task "release", "releases the project", (options) ->
  jsp = require("uglify-js").parser
  pro = require("uglify-js").uglify

  version = current_version()

  orig_code = fs.readFileSync "./dist/ahoy.js", "utf8"
  fs.writeFileSync "./releases/ahoy-#{version}.js", orig_code, "utf8"

  ast = jsp.parse orig_code       # parse code and get the initial AST
  ast = pro.ast_mangle ast        # get a new AST with mangled names
  ast = pro.ast_squeeze ast       # get an AST with compression optimizations
  final_code = pro.gen_code ast   # compressed code here

  fs.writeFileSync "./releases/ahoy-#{version}.min.js", final_code, "utf8"
  console.log "Release successful"

# helper functions

current_version = ->
  version = fs.readFileSync "./VERSION", "utf8"
  throw "Version not found." unless version
  version

run = (command, callback) ->
  exec command, (error, stdout, stderr) ->
    console.log stdout.trim()
    if error
      console.error stderr.trim()

    callback(error, stdout, stderr) if callback?
