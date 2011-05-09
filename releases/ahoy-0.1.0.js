(function() {
  var ahoy, direct, doubleclick, facebook, google, paid_search, root, search, website;
  ahoy = {
    options: {
      cookieName: "ahoy",
      onArrival: null
    },
    matey: function() {
      var callback, cookieName, source;
      cookieName = this.options.cookieName;
      callback = this.options.onArrival;
      source = this.getSourceFromCookie(cookieName);
      if (!((source != null) && false)) {
        source = this.parseQuery(window.location.href);
                if (source != null) {
          source;
        } else {
          source = this.parseReferrer(document.referrer);
        };
        this.Cookie.set(cookieName, this.JSON.stringify(source));
        if (this.Cookie.get(cookieName)) {
          if (callback != null) {
            return callback(source);
          }
        }
      }
    },
    cookieName: function(name) {
      return this.options.cookieName = name;
    },
    onArrival: function(callback) {
      return this.options.onArrival = callback;
    },
    getSourceFromCookie: function(name) {
      var cookie;
      if (cookie = this.Cookie.get(name)) {
        try {
          return this.JSON.parse(cookie);
        } catch (error) {
          this.Cookie.unset(name);
        }
      }
      return null;
    },
    getHostsToCheck: function(host) {
      var h, hostParts;
      h = [host];
      hostParts = host.split(".");
      while (hostParts.shift()) {
        h.push(hostParts.join("."));
      }
      return h;
    },
    parseQuery: function(url) {
      var encoded_source, uri;
      uri = this.URI.parse(url);
      if (encoded_source = uri.params["ahoy"]) {
        try {
          return null;
        } catch (error) {

        }
      }
      return null;
    },
    parseReferrer: function(url) {
      var data, hostsToCheck, uri;
      data = url.length === 0 ? this.matchHost(["(direct)"]) : (uri = this.URI.parse(url), hostsToCheck = this.getHostsToCheck(uri.fullHost), this.matchHost(hostsToCheck, uri));
      data.referrer = url;
      data.arrived_at = (new Date).toString();
      return data;
    },
    matchHost: function(hostsToCheck, uri) {
      var h, host, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = hostsToCheck.length; _i < _len; _i++) {
        host = hostsToCheck[_i];
        if (h = this.hosts[host]) {
          if (typeof h === "function") {
            return h(uri);
          } else {
            return h[0](h[1], h[2], h[3])(uri);
          }
        }
      }
      return _results;
    }
  };
  root = typeof exports !== "undefined" && exports !== null ? exports : this;
  root.ahoy = ahoy;
  direct = function() {
    return {
      "name": "(direct)",
      "category": "(direct)"
    };
  };
  website = function(uri) {
    return {
      "name": uri.host,
      "category": "referral"
    };
  };
  search = function(query_param) {
    return function(uri) {
      return {
        "name": uri.host,
        "category": "search",
        "extra": uri.params[query_param]
      };
    };
  };
  paid_search = function(query_param) {
    return function(uri) {
      return {
        "name": uri.host,
        "category": "paid search",
        "extra": uri.params[query_param]
      };
    };
  };
  google = function(uri) {
    if (uri.path === "/aclk") {
      return paid_search("q")(uri);
    } else {
      return search("q")(uri);
    }
  };
  facebook = function(uri) {
    if (uri.path === "/ajax/emu/end.php") {
      return ad(uri);
    } else {
      return website(uri);
    }
  };
  doubleclick = function(uri) {
    var ad_uri, data, url;
    url = uri.queryKey["url"];
    ad_uri = URI.parse(url);
    return data = ad_network(ad_uri, "DoubleClick");
  };
  ahoy.hosts = {
    "(direct)": direct,
    "": website,
    "www.google.com": google,
    "facebook.com": facebook,
    "g.doubleclick.net": doubleclick,
    "www.daum.net": [search, "q"],
    "www.eniro.se": [search, "search_word"],
    "www.naver.com": [search, "query"],
    "www.yahoo.com": [search, "p"],
    "www.msn.com": [search, "q"],
    "www.bing.com": [search, "q"]
  };
  ahoy.Cookie = {
    get: function(key) {
      var tmp;
      tmp = document.cookie.match(new RegExp(key + '=[^;]+($|;)', 'g'));
      if (!tmp || !tmp[0]) {
        return null;
      } else {
        return unescape(tmp[0].substring(key.length + 1, tmp[0].length).replace(';', '')) || null;
      }
    },
    set: function(key, value, ttl, path, domain, secure) {
      var cookie;
      cookie = [key + '=' + escape(value)];
      if (path) {
        cookie.push("path=" + path);
      }
      if (domain) {
        cookie.push("domain=" + domain);
      }
      if (ttl) {
        cookie.push(this.hoursToExpireDate(ttl));
      }
      if (secure) {
        cookie.push("secure");
      }
      return document.cookie = cookie.join("; ");
    },
    unset: function(key) {
      return this.set(key, "", -1);
    },
    hoursToExpireDate: function(ttl) {
      var now;
      if (parseInt(ttl) === "NaN") {
        return "";
      }
      now = new Date();
      now.setTime(now.getTime() + (parseInt(ttl) * 60 * 60 * 1000));
      return now.toGMTString();
    }
  };
  ahoy.URI = {
    parse: function(str) {
      var i, m, mode, o, uri;
      o = this.options;
      mode = o.strictMode ? "strict" : "loose";
      m = o.parser[mode].exec(str);
      uri = {};
      i = 14;
      while (i--) {
        uri[o.key[i]] = m[i] || "";
      }
      uri[o.q.name] = {};
      uri[o.key[12]].replace(o.q.parser, function($0, $1, $2) {
        if ($1) {
          return uri[o.q.name][$1] = decodeURIComponent($2.replace("+", "%20"));
        }
      });
      uri.host = uri.fullHost.substring(0, 4) === "www." ? uri.fullHost.substring(4) : uri.fullHost;
      return uri;
    },
    options: {
      strictMode: false,
      key: ["source", "protocol", "authority", "userInfo", "user", "password", "fullHost", "port", "relative", "path", "directory", "file", "query", "anchor"],
      q: {
        name: "params",
        parser: /(?:^|&)([^&=]*)=?([^&]*)/g
      },
      parser: {
        strict: /^(?:([^:\/?#]+):)?(?:\/\/((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?))?((((?:[^?#\/]*\/)*)([^?#]*))(?:\?([^#]*))?(?:#(.*))?)/,
        loose: /^(?:(?![^:@]+:[^:@\/]*@)([^:\/?#.]+):)?(?:\/\/)?((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?)(((\/(?:[^?#](?![^?#\/]*\.[^?#\/.]+(?:[?#]|$)))*\/?)?([^?#\/]*))(?:\?([^#]*))?(?:#(.*))?)/
      }
    }
  };
  ahoy.JSON = {
    parse: function(data) {
      var rvalidbraces, rvalidchars, rvalidescape, rvalidtokens;
      if (typeof data !== "string") {
        return null;
      }
      data = data.trim();
      if ((typeof window !== "undefined" && window !== null) && (window.JSON != null) && (window.JSON.parse != null)) {
        return window.JSON.parse(data);
      }
      rvalidchars = /^[\],:{}\s]*$/;
      rvalidescape = /\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g;
      rvalidtokens = /"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g;
      rvalidbraces = /(?:^|:|,)(?:\s*\[)+/g;
      if (rvalidchars.test(data.replace(rvalidescape, "@").replace(rvalidtokens, "]").replace(rvalidbraces, ""))) {
        return (new Function( "return " + data ))();
      }
      throw "Invalid JSON: " + data;
    },
    stringify: function(data) {
      var key, props, val;
      if ((typeof window !== "undefined" && window !== null) && (window.JSON != null) && (window.JSON.stringify != null)) {
        return window.JSON.stringify(data);
      }
      props = (function() {
        var _results;
        _results = [];
        for (key in data) {
          val = data[key];
          val = typeof val === "string" ? '"' + val.replace(/"/g, '\\"') + '"' : "null";
          _results.push('"' + key + '":' + val);
        }
        return _results;
      })();
      return "{" + props.join(",") + "}";
    }
  };
}).call(this);
