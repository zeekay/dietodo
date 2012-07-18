md    = require('markdown').markdown
fs    = require 'fs'

# database
dirty = require 'dirty'
db = dirty __dirname + '/todo.db'

# unique id generator
uuid  = require 'node-uuid'

app = require('die')
  base: __dirname

app.extend ->
  # look at die/src/extend.coffee for a list of:
  #
  #       * route handlers: all, get, post, put, del
  #
  #       * helper methods: app, body, next, params, query, req, res, session,
  #                         settings, json, redirect, render, send
  #
  @get '/', ->
    # render jade template file: views/index.jade
    # NOTE: files are automatically searched inside views/
    @render 'index'

  # API for interacting with Backbone Todo Model
  # RESTful HTTP Methods map out to CRUD
  #
  # Create -> POST   -> @post
  # Read   -> GET    -> @get
  # Delete -> DELETE -> @del
  # Update -> PUT    -> @put

  # Request handler that maps a url to an http method
  @post '/api/todos', ->
    # this is a context consisting of numerous helper methods and attributes
    # @body is the request body which is going to be a JSON object representing the
    # Todo Model to be created in the database.
    todo = @body
    # Backbone expects us to add an id to objects we save, when we send them
    # back to the client the id signifies to Backbone that the instance has
    # already been saved, and subsequently it will use PUT requests to update
    # it.
    todo.id = uuid.v4()
    # Save todo instance to database
    db.set id, todo
    # If you don't send anything back this route will hang.
    @send 'ok'

  @get '/api/todos', ->
    collection = []
    db.forEach (id, todo) ->
      todo.id = id
      collection.push todo

    # This is a helper method which returns a JSON response
    @json collection


module.exports = app
