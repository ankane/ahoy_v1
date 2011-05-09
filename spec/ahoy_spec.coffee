ahoy = require("../dist/ahoy.js").ahoy

describe "ahoy", ->

  it "should be direct with no referrer", ->
    data = ahoy.parseReferrer("")
    expect(data.name).toEqual("(direct)")
