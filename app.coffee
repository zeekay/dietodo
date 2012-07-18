md    = require('markdown').markdown
fs    = require 'fs'

# database
dirty = require 'dirty'
db = dirty __dirname + '/todo.db'

# unique id generator
uuid  = require 'node-uuid'

app = require('die')
  base: __dirname

# NOTE: look at die/src/extend.coffee for a list of helper methods available to
# route handlers ('all', 'get', 'post', 'put', 'del')
app.extend ->
  @set 'view options',
    layout: false

  @get '/', ->
    # TODO DELETE
    console.log "get"
    testID = uuid.v4()
    db.set testID, {title : "todo title place holder"}
    console.log "db.get: #{db.get testID}"

    fs.readFile __dirname + '/README.md', 'utf8', (err, content) =>
      @render 'index', readme: md.toHTML content

  # API for interacting with Backbone Todo Model
  # RESTful HTTP Methods map out to CRUD
  #
  # Create -> POST
  # Read   -> GET
  # Delete -> DELETE
  # Update -> PUT

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
