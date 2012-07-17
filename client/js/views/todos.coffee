# TODO how is clash not requiring Backbone in views ???
Backbone = require 'backbone'

class TodosView extends Backbone.View
  tagName: 'ul'
  className: 'todos'

  template: require '../templates/commits'

  render: ->
    subviews = []
    $('#content').html @template(subviews)

module.exports = TodosView
