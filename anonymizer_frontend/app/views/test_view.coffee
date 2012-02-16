{ResultView} = require 'views/result_view'
testTemplate = require './templates/test'

class exports.TestView extends Backbone.View
  
  id: 'test'

  initialize: ->
    app.sample.bind "change", @getTestResults
    app.sample.bind "reset", @clear
    @collection.bind 'add', @addOne
    @collection.bind 'reset', @addAll

  render: ->
    $(@el).replaceWith testTemplate

  addOne: (result) ->
    view = new ResultView model: result
    $(@el).append( view.render().el )

  addAll: =>
    @render()
    @collection.models.forEach @addOne

  getTestResults: ->
    app.sample.test()

  clear: =>
    @collection.reset()
