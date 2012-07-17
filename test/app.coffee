assert  = require 'assert'
zombie  = require 'zombie'
browser = new zombie.Browser
app     = require '../'

describe 'dietodo', ->
  describe 'GET /', ->
    before (done) ->
      app.listen app.settings.port, ->
        browser.visit "http://localhost:#{app.settings.port}/", -> done()

    it 'Index has title', ->
      title = browser.text 'title'
      assert.equal title, 'dietodo'
