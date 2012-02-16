replaceTemplate = require './templates/replace'

class exports.ReplaceView extends Backbone.View

  initialize: ->
    @model.bind 'all', @render

  render: =>
    @$(@el).html replaceTemplate sample: @model
    this
