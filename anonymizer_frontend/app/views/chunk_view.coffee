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
    console.log("rendering chunk view")
    @$(@el).html chunkTemplate chunk: @model
    if @model.get('anonymize')
      @$(@el).addClass('anonymize')
    else
      @$(@el).removeClass('anonymize')

    this

  toggleAnonymize: ->
    console.log("toggling anonymize")
    @model.toggleAnonymize()
