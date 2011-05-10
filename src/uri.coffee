# parseUri 1.2.2
# (c) Steven Levithan <stevenlevithan.com>
# MIT License

ahoy.URI =

  parse: (str) ->
    o   = this.options
    mode = if o.strictMode then "strict" else "loose"
    m   = o.parser[mode].exec(str)
    uri = {}
    i   = 14

    while (i--)
      uri[o.key[i]] = m[i] || ""

    uri[o.q.name] = {}
    uri[o.key[12]].replace(o.q.parser, ($0, $1, $2) ->
      # make sure URI's are decoded properly
      # http://stackoverflow.com/questions/4292914/javascript-url-decode-function/4458580#4458580
      if ($1)
        uri[o.q.name][$1] = decodeURIComponent($2.replace("+", "%20"))
    )

    # strip www
    uri.shortHost =
    if uri.host.substring(0, 4) == "www."
      uri.host.substring(4)
    else
      uri.host

    uri

  options:
    strictMode: false
    key: ["source","protocol","authority","userInfo","user","password","host","port","relative","path","directory","file","query","anchor"]
    q:
      name:   "params",
      parser: /(?:^|&)([^&=]*)=?([^&]*)/g
    parser:
      strict: /^(?:([^:\/?#]+):)?(?:\/\/((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?))?((((?:[^?#\/]*\/)*)([^?#]*))(?:\?([^#]*))?(?:#(.*))?)/
      loose:  /^(?:(?![^:@]+:[^:@\/]*@)([^:\/?#.]+):)?(?:\/\/)?((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?)(((\/(?:[^?#](?![^?#\/]*\.[^?#\/.]+(?:[?#]|$)))*\/?)?([^?#\/]*))(?:\?([^#]*))?(?:#(.*))?)/
