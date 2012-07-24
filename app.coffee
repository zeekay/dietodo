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
  @configure ->
    @use @middleware.bodyParser()

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

  # STOP TODO
  #
  # create all 4 url methods and check wich one is called with
  # Collection.create()


  @post '/api/todos', ->
    console.log "\n  app.coffee: @post '/api/todos', ->\n"
    console.log @body
    console.log "\n"

    todo = @body
    todo.id = uuid.v4()

    db.set todo.id, todo
    @send 'ok'


  @get '/api/todos', ->
    console.log "\n  app.coffee: @get '/api/todos', ->\n"

    collection = []
    db.forEach (id, todo) ->
      todo.id = id
      collection.push todo
    @json collection


  #@put '/api/todos', ->
  #  console.log "\n  app.coffee: @put '/api/todos', ->\n"
  #  @send 'ok'



  @put '/api/todos/:id', (id) ->
    #@put '/api/todos', () ->
    #console.log "\n app.coffee: @put '/api/todos:#{id}', -> \n"
    console.log "\n app.coffee: @put '/api/todos', -> \n"
    console.log id

    #console.log @body
    todo = @body
    db.set id, todo
    @send 'ok'



module.exports = app
