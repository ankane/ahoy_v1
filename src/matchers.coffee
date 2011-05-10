# standard

direct = ->
  {"site": "(direct)", "category": "(direct)"}

website = (uri) ->
  {"category": "referral"}

# helpers

search = (query_param) ->
  (uri) ->
    {"category": "search", "info": "query > #{uri.params[query_param]}"}

paid_search = (query_param) ->
  (uri) ->
    {"category": "paid search", "info": "query > #{uri.params[query_param]}"}

ad = (uri) ->
  {"category": "ad"}

# services

google = (uri) ->
  if uri.path == "/aclk"
    paid_search("q")(uri)
  else
    search("q")(uri)

facebook = (uri) ->
  if uri.path == "/ajax/emu/end.php"
    ad uri
  else
    website uri

doubleclick = (uri) ->
  url = uri.params["url"]
  ad_uri = ahoy.URI.parse url
  source = ad ad_uri
  source.site = ad_uri.shortHost
  source.info = "doubleclick ad"
  source
