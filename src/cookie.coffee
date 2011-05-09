# @author   Maxime Haineault (max@centdessin.com)
# @version  0.3
# @desc   JavaScript cookie manipulation class

ahoy.Cookie =

  get: (key) ->
    # Still not sure that "[a-zA-Z0-9.()=|%/]+($|;)" match *all* allowed characters in cookies
    tmp =  document.cookie.match((new RegExp(key+'=[^;]+($|;)','g')))
    if(!tmp || !tmp[0])
      null
    else
      unescape(tmp[0].substring(key.length+1,tmp[0].length).replace(';','')) || null

  set: (key, value, ttl, path, domain, secure) ->
    cookie = [key+'='+escape(value)]

    if path
      cookie.push "path=" + path
    if domain
      cookie.push "domain=" + domain
    if ttl
      cookie.push this.hoursToExpireDate(ttl)
    if secure
      cookie.push "secure"
    document.cookie = cookie.join "; "

  unset: (key) ->
    this.set key, "", -1

  hoursToExpireDate: (ttl) ->
    return "" if parseInt(ttl) == "NaN"
    now = new Date()
    now.setTime(now.getTime() + (parseInt(ttl) * 60 * 60 * 1000))
    now.toGMTString()
