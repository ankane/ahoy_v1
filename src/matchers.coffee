# standard

direct = ->
  {"name": "(direct)", "category": "(direct)"}

website = (uri) ->
  {"name": uri.host, "category": "referral"}

# helpers

search = (query_param) ->
  (uri) ->
    {"name": uri.host, "category": "search", "extra": uri.params[query_param]}

paid_search = (query_param) ->
  (uri) ->
    {"name": uri.host, "category": "paid search", "extra": uri.params[query_param]}

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
  url = uri.queryKey["url"]
  ad_uri = URI.parse url
  data = ad_network(ad_uri, "DoubleClick")
