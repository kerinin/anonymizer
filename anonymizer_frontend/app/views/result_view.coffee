resultTemplate = require './templates/result'

class exports.ResultView extends Backbone.View

  initialize: ->
    @model.bind 'all', @render

  render: =>
    $("#test").append resultTemplate result: @model
