resultTemplate = require './templates/result'

class exports.ResultView extends Backbone.View

  tagName: 'tr'

  initialize: ->
    @model.bind 'all', @render

  render: =>
    $(@el).html resultTemplate result: @model
    this
