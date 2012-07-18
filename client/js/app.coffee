# TODO require client side stuff like it is done in clash
Backbone = require 'backbone'

# TODO require some kind client side uid generator
#uuid  = require 'node-uuid'


# ==============================================================================
# MODELS
# ==============================================================================
class Todo extends Backbone.Model
  urlRoot = '/api/todos'

class Todos extends Backbone.Collection
  model: Todo
  url: '/api/todos'


# ==============================================================================
# VIEWS
# ==============================================================================
class TodoView extends Backbone.View
  className: 'todo'
  initialize: (model) ->
    @model = model
  render: ->
    # TODO: create TodosView jade template
    $(@el).html @model.get('title')
    @

# renders Backbone.Collection Todos
class TodosView extends Backbone.View
  className: 'todos'
  initialize: (collection) ->
    @collection = collection

  template: require './templates/todos'
  render: ->
    # generate rendered list of single todo view items from @collection
    todos = []
    for model in @collection.models
      todo = new TodoView model
      todo.render()
      todos.push todo.$el.html()

    # subviews will be used as the jade template context: members of subviews
    # will be available as jade variables
    subviews = {todos: todos}
    $(@el).html @template(subviews)
    @

# view wrapper for the whole app: contains interfaces to add / remove todos
class AppView extends Backbone.View
  className: 'app'
  template: require './templates/app'

  # collection: Todos Backbone collection
  initialize: (collection) ->
    @collection = collection

  # wrapper: jQuery DOM object that will wrap this view
  render: (wrapper)->
    # render app UI
    $(@el).html @template()

    # render todo list
    @todosView = new TodosView @collection
    @todosView.render()

    # append UI and todo list to wrapper to display view
    $(@el).append @todosView.$el
    wrapper.append $(@el)
    @

# ==============================================================================
# ROUTES
# ==============================================================================
class Router extends Backbone.Router
  initialize: (collection) ->
    @collection = collection

  routes:
    'add': 'add'
    'del': 'del'

  add: ->
    # TODO DELETE
    window.collection = @collection

    todo = new Todo {id: 'asdf', title: 'todo added from client'}
    @collection.add todo
    @navigate()



# ==============================================================================
# APP
# ==============================================================================
class App
  constructor: ->
    # create a global instance of our todos collection
    @collection = new Todos

    # fetch collection from database
    @collection.fetch
      success: (collection, response) =>

        @router = new Router @collection
        Backbone.history.start()

        # display app
        @appView = new AppView @collection
        @appView.render($('#content'))

      error: (collection, response) ->
        # display error
        document.write "client/js/app.coffee:App: " + response.responseText


module.exports = app = new App()
