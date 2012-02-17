searchTemplate = require './templates/_search'

class exports.SearchView extends Backbone.View

  initialize: ->
    @model.bind 'all', @render

  render: =>
    @$(@el).html searchTemplate sample: @model
    this

