filterTemplate = require './templates/_filter'

class exports.FilterView extends Backbone.View
  id: 'filter'

  initialize: =>
    @router = @options['router']
    @sample = @options['sample']

    @bind() if @options['bind'] isnt false

  bind: =>
    @sample.bind 'all', @render

  unbind: =>
    @sample.bind 'all', @render

  remove: =>
    @unbind()
    @$(@el).remove()

  render: =>
    @$(@el).html filterTemplate sample: @sample
    this

