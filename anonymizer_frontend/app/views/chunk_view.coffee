chunkTemplate = require './templates/chunk'

class exports.ChunkView extends Backbone.View

  tagName: 'span'
  className: 'chunk'

  events: 
    'click': 'toggleAnonymize'

  initialize: ->
    @model.bind 'all', @render
    @model.view = this

  render: =>
    @$(@el).html chunkTemplate chunk: @model
    if @model.get('anonymize')
      @$(@el).addClass('anonymize')
    else
      @$(@el).removeClass('anonymize')

    this

  toggleAnonymize: ->
    @model.toggleAnonymize()
