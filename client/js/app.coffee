Backbone = require 'backbone'
_ = require 'underscore'


class Todo extends Backbone.Model
  # binds to server side CRUD methods. Look at: /app.coffee
  urlRoot: '/api/todos'

class TodoList extends Backbone.Collection
  model: Todo
  # binds to server side CRUD methods. Look at: /app.coffee
  url: '/api/todos'

Todos = new TodoList()


class TodoView extends Backbone.View
  tagName: 'li'
  # TODO: how does this template work?
  #template: _.template($('#item-template').html())

  initialize: ->
    @model.bind 'change', @render, @

  render: ->
    @$el.html(@template(@model.toJSON()))
    @


class AppView extends Backbone.View

  el: $('#content')

  initialize: ->
    Todos.bind 'all', @test, @

  test: (eventType)->
    console.log "AppView.test #{eventType}"



# ==============================================================================
# TESTING
# ==============================================================================
window.testCreate = ->

  Todos.create({title: 'new model from testPUT'}, {
    error: (model, response) ->
      console.log "testCreate error: Todos.create()"
      console.log response.error()
    success: ->
      console.log "testCreate success"
      Todos.models[Todos.size()-1].set {title: 'modify model in testPUT'}
  })
window.Todos = Todos
window.app = new AppView()

window.testSave = ->
  #Todos.models[0].save {title: 'modify'}

  Todos.models[0].set({title: 'modify2'})

  console.log Todos.models[0].get('title')
  Todos.fetch
    success: ->
      console.log Todos.models[0].get('title')

  #Todos.models[0].save {title: 'modify again'}, {
  #  error: (model, response) ->
  #    console.log "testSave error: Todos.create()"
  #    console.log response.error()
  #  success: ->
  #    console.log "testSave success"
  #}

Todos.fetch()
# ==============================================================================

module.exports = window.app
