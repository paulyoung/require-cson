###
  http://github.com/paulyoung/require-cson
###
define [
  'coffee-script'
  'text'
], (CoffeeScript, text) ->
  buildMap = {}

  load: (name, req, onLoad, config) ->
    if config.isBuild
      text.get req.toUrl("#{name}.cson"), (data) ->
        try
          # `bare: true` required in CoffeeScript Compiler v1.2.0
          data = JSON.stringify(CoffeeScript.eval(data,
            bare: true
            sandbox: true
          ))
        catch err
          throw (err)

        buildMap[name] = data

    onLoad null

  write: (pluginName, moduleName, write) ->
    if moduleName of buildMap
      write """define(\"#{pluginName}!#{moduleName}\", function() {
        return #{buildMap[moduleName]};
      });\n"""
