ahoy =

  options:
    cookieName: "ahoy"
    onArrival: null

  matey: ->
    cookieName = this.options.cookieName
    callback = this.options.onArrival

    source = this.getSourceFromCookie cookieName

    unless source?
      source = this.parseQuery window.location.href
      source ?= this.parseReferrer document.referrer
      this.Cookie.set cookieName, this.JSON.stringify(source)

      # fire callback if cookie set successfully set
      if this.Cookie.get cookieName
        callback(source) if callback?

  cookieName: (name) ->
    this.options.cookieName = name

  onArrival: (callback) ->
    this.options.onArrival = callback

  getSourceFromCookie: (name) ->
    if cookie = this.Cookie.get name
      try
        return this.JSON.parse cookie
      catch error
        this.Cookie.unset name
    null

  getHostsToCheck: (host) ->
    h = [host]
    hostParts = host.split(".")
    while hostParts.shift()
      h.push hostParts.join(".")
    h

  parseQuery: (url) ->
    uri = this.URI.parse url
    if encoded_source = uri.params["ahoy"]
      try
        # TODO: parse encoded_source
        return null
      catch error
        # do nothing
    null

  parseReferrer: (url) ->
    data =
    if url.length == 0
      this.matchHost(["(direct)"])
    else
      uri = this.URI.parse url
      hostsToCheck = this.getHostsToCheck(uri.fullHost)
      this.matchHost(hostsToCheck, uri)

    data.referrer = url
    data.arrived_at = (new Date).toString()
    data

  matchHost: (hostsToCheck, uri) ->
    for host in hostsToCheck
      if h = this.hosts[host]
        if typeof h == "function"
          return h(uri)
        else
          return h[0](h[1], h[2], h[3])(uri)

# export
root = exports ? this
root.ahoy = ahoy
