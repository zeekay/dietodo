# TODO require client side stuff like it is done in clash
Backbone = require 'backbone'

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



class App
  constructor: ->
    # create a global instance of our todos collection
    @todos = new Todos
    # fetch collection from database
    @todos.fetch
      success: (collection, response) =>
        # display app
        @todosView = new TodosView @todos
        @todosView.render()
        $('#content').html @todosView.$el.html()

      error: (collection, response) ->
        # display error
        document.write "client/js/app.coffee:App: " + response.responseText


module.exports = app = new App()
