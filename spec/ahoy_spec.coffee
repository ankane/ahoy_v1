ahoy = require("../dist/ahoy.js").ahoy

checkSource = (referrer, name, category, extra=null) ->
  source = ahoy.parseReferrer(referrer)
  expect(source.name).toEqual(name)
  expect(source.category).toEqual(category)
  expect(source.extra).toEqual(extra)

describe "ahoy", ->

  describe "sources", ->

    it "direct", ->
      checkSource "", "(direct)", "(direct)"

    it "referral", ->
      checkSource "http://www.example.org", "example.org", "referral"

    it "google organic", ->
      checkSource "http://www.google.com/?q=test", "google.com", "search", "test"

    it "google paid", ->
      checkSource "http://www.google.com/aclk?q=test", "google.com", "paid search", "test"

    it "facebook", ->
      checkSource "http://www.facebook.com/l.php", "facebook.com", "referral"

    it "facebook ad", ->
      checkSource "http://www.facebook.com/ajax/emu/end.php", "facebook.com", "ad"

    it "bing organic", ->
      checkSource "http://www.bing.com/?q=test", "bing.com", "search", "test"

    it "doubleclick", ->
      checkSource "http://googleads.g.doubleclick.net/pagead/ads?url=http%3A//www.example.org", "example.org", "ad", "doubleclick"
