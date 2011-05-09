ahoy.JSON =

  # ported from JQuery
  parse: (data) ->
    return null if typeof data != "string"

    data = data.trim()

    if window? and window.JSON? and window.JSON.parse?
      return window.JSON.parse(data)

    # JSON RegExp
    rvalidchars = /^[\],:{}\s]*$/
    rvalidescape = /\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g
    rvalidtokens = /"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g
    rvalidbraces = /(?:^|:|,)(?:\s*\[)+/g

    if rvalidchars.test(data.replace(rvalidescape, "@").replace(rvalidtokens, "]").replace(rvalidbraces, ""))
      return `(new Function( "return " + data ))()`

    throw "Invalid JSON: " + data

  # super simple stringify implementation
  # only handles strings and null
  stringify: (data) ->
    if window? and window.JSON? and window.JSON.stringify?
      return window.JSON.stringify(data)

    props = for key, val of data
      val = if typeof val == "string" then '"' + val.replace(/"/g, '\\"') + '"' else "null"
      '"' + key + '":' + val

    "{" + props.join(",") + "}"
