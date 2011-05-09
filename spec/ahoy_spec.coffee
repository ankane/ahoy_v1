ahoy = require("../dist/ahoy.js").ahoy

checkSource = (referrer, name, category, extra) ->
  source = ahoy.parseReferrer(referrer)
  expect(source.name).toEqual(name)
  expect(source.category).toEqual(category)
  expect(source.extra).toEqual(extra)

describe "ahoy", ->

  it "direct", ->
    checkSource "", "(direct)", "(direct)", null

  it "google organic", ->
    checkSource "http://www.google.com/?q=test", "google.com", "search", "test"
