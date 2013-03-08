{print} = require 'util'
{spawn, exec} = require 'child_process'

# After plugin is built, build demo app
callback = ->
  exec './node_modules/.bin/r.js -o demo/build-config.js', (err, stdout, stderr) ->
    if err or stderr
      console.log err
      console.log stderr
    else
      console.log "Build lib/cson.js and demo/main.out.js"


task 'build', 'Build /lib from /src', ->
  coffee = spawn 'coffee', ['-c', '-b', '-o', 'lib', 'src']
  coffee.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  coffee.stdout.on 'data', (data) ->
    print data.toString()
  coffee.on 'exit', (code) ->
    callback?() if code is 0
