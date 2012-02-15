searchTemplate = require './templates/search'

class exports.SearchView extends Backbone.View

  initialize: ->
    @model.bind 'all', @render

  render: =>
    console.log("rendering search view")
    @$(@el).html searchTemplate sample: @model
    this
