filterTemplate = require './templates/_filter'

class exports.FilterView extends Backbone.View
  id: 'filter'

  initialize: =>
    @router = @options['router']
    @redactor = @options['redactor']

    @bind() if @options['bind'] isnt false

  bind: =>
    @redactor.bind 'all', @render

  unbind: =>
    @redactor.bind 'all', @render

  remove: =>
    @unbind()
    @$(@el).remove()

  render: =>
    @$(@el).html filterTemplate redactor: @redactor
    this

