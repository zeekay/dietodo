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

  #initialize: ->
  #  Todos.bind 'all', @test, @

  #test: (eventType)->
  #  console.log "AppView.test #{eventType}"



# ==============================================================================
# TESTING
# ==============================================================================
window.Todos = Todos
window.app = new AppView()

window.testCreate = (cb)->
  Todos.create({title: 'new'}, {
    error: (model, response) ->
      console.log "testCreate error: Todos.create()"
      console.log response.error()
    success: ->
      if _.last(Todos.models).get('title') == 'new'
        console.log "testCreate success"
        cb.success() if cb.success
      else
        console.log "testCreate error: wrong title"
        cb.error() if cb.error
  })

# create new todo item with testCreate and then modify its title
window.testSave = ->
  window.testCreate(
    success: ->
      before = _.last(Todos.models).get('title')
      _.last(Todos.models).save({title: 'modified'}
        success: ->
          after = _.last(Todos.models).get('title')
          if before == 'new' && after == 'modified'
            console.log "testSave success"
          else
            console.log "testSave error: wrong titles"
      )
  )


Todos.fetch({success: -> testSave()})
# ==============================================================================

module.exports = window.app
