ahoy = require("../dist/ahoy.js").ahoy

checkSource = (referrer, site, category, info=null) ->
  source = ahoy.parseReferrer(referrer)
  expect(source.site).toEqual(site)
  expect(source.category).toEqual(category)
  expect(source.info).toEqual(info)

describe "ahoy", ->

  describe "sources", ->

    it "direct", ->
      checkSource "", "(direct)", "(direct)"

    it "referral", ->
      checkSource "http://www.example.org", "example.org", "referral"

    it "google organic", ->
      checkSource "http://www.google.com/?q=test", "google.com", "search", "query > test"

    it "google paid", ->
      checkSource "http://www.google.com/aclk?q=test", "google.com", "paid search", "query > test"

    it "facebook", ->
      checkSource "http://www.facebook.com/l.php", "facebook.com", "referral"

    it "facebook ad", ->
      checkSource "http://www.facebook.com/ajax/emu/end.php", "facebook.com", "ad"

    it "bing organic", ->
      checkSource "http://www.bing.com/?q=test", "bing.com", "search", "query > test"

    it "doubleclick", ->
      checkSource "http://googleads.g.doubleclick.net/pagead/ads?url=http%3A//www.example.org", "example.org", "ad", "doubleclick ad"
