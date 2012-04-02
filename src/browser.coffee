# Override exported methods for non-Node.js engines.

Caffeine = require './caffeine'
Caffeine.require = require

# Use standard JavaScript `eval` to eval code.
Caffeine.eval = (code, options = {}) ->
  options.bare ?= on
  eval Caffeine.compile code, options

# Running code does not provide access to this scope.
Caffeine.run = (code, options = {}) ->
  options.bare = on
  Function(Caffeine.compile code, options)()

# If we're not in a browser environment, we're finished with the public API.
return unless window?

# Load a remote script from the current domain via XHR.
Caffeine.load = (url, callback) ->
  xhr = if window.ActiveXObject
    new window.ActiveXObject('Microsoft.XMLHTTP')
  else
    new XMLHttpRequest()
  xhr.open 'GET', url, true
  xhr.overrideMimeType 'text/plain' if 'overrideMimeType' of xhr
  xhr.onreadystatechange = ->
    if xhr.readyState is 4
      if xhr.status in [0, 200]
        Caffeine.run xhr.responseText
      else
        throw new Error "Could not load #{url}"
      callback() if callback
  xhr.send null

# Activate Caffeine in the browser by having it compile and evaluate
# all script tags with a content-type of `text/coffeescript`.
# This happens on page load.
runScripts = ->
  scripts = document.getElementsByTagName 'script'
  coffees = (s for s in scripts when s.type is 'text/coffeescript')
  index = 0
  length = coffees.length
  do execute = ->
    script = coffees[index++]
    if script?.type is 'text/coffeescript'
      if script.src
        Caffeine.load script.src, execute
      else
        Caffeine.run script.innerHTML
        execute()
  null

# Listen for window load, both in browsers and in IE.
if window.addEventListener
  addEventListener 'DOMContentLoaded', runScripts, no
else
  attachEvent 'onload', runScripts
