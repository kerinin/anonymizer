searchTemplate = require './templates/_search'

class exports.SearchView extends Backbone.View

  initialize: ->
    @router = @options['router']
    @sample = @options['sample']

    @sample.bind 'all', @render

  render: =>
    @$(@el).html searchTemplate sample: @sample
    this

