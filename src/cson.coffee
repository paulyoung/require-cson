###
  http://github.com/paulyoung/require-cson
###

{nodeRequire} = require

define [
  'coffee-script'
], (CoffeeScript) ->
  progIds = [
    "Msxml2.XMLHTTP"
    "Microsoft.XMLHTTP"
    "Msxml2.XMLHTTP.4.0"
  ]

  fetchText = ->
    throw new Error("Environment unsupported.")

  if process?.versions?.node?
    fs = nodeRequire 'fs'

    fetchText = (path, callback) ->
      callback fs.readFileSync path, "utf8"

  else if (window?.navigator? and window?.document?) or importScripts?
    getXhr = ->
      if XMLHttpRequest?
        return new XMLHttpRequest()
      else
        i = 0
        while i < 3
          progId = progIds[i]
          try
            xhr = new ActiveXObject(progId)
          if xhr
            progIds = [progId] # so faster next time
            break
          i += 1
      throw new Error("getXhr(): XMLHttpRequest not available") unless xhr

      return xhr

    fetchText = (url, callback) ->
      xhr = getXhr()
      xhr.open "GET", url, true
      xhr.onreadystatechange = (evt) ->
        callback xhr.responseText if xhr.readyState is 4

      xhr.send null

  else if Packages?
    fetchText = (path, callback) ->
      stringBuffer = undefined
      line = undefined
      encoding = "utf-8"
      file = new java.io.File(path)
      lineSeparator = java.lang.System.getProperty("line.separator")
      input = new java.io.BufferedReader(new java.io.InputStreamReader(new java.io.FileInputStream(file), encoding))
      content = ""

      try
        stringBuffer = new java.lang.StringBuffer()
        line = input.readLine()
        line = line.substring(1) if line and line.length() and line.charAt(0) is 0xfeff
        stringBuffer.append line
        while (line = input.readLine()) isnt null
          stringBuffer.append lineSeparator
          stringBuffer.append line

        content = String(stringBuffer.toString())
      finally
        input.close()

      callback content


  buildMap = {}

  load: (name, req, onLoad, config) ->
    if config.isBuild
      fetchText req.toUrl("#{name}.cson"), (data) ->
        try
          # `bare: true` required in CoffeeScript Compiler v1.2.0
          data = JSON.stringify CoffeeScript.eval data,
            bare: true
            sandbox: true
        catch err
          throw err

        buildMap[name] = data

        onLoad data
    else
      onLoad null

  write: (pluginName, moduleName, write) ->
    if moduleName of buildMap
      write.asModule pluginName + "!" + moduleName,
        """
        define(function() {
          return #{buildMap[moduleName]};
        });
        """
