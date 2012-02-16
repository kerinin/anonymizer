chunkReplaceTemplate = require './templates/replace_chunk'

class exports.ChunkReplaceView extends Backbone.View
  tagName: 'span'

  events:
    'blur input': 'updateAlias'

  initialize: ->
    @tagName = (if @model.get('anonymize') then 'input' else 'span')
    @model.bind 'all', @render

  render: =>
    @$(@el).html chunkReplaceTemplate chunk: @model
    this

  updateAlias: ->
    if @model.get('anonymize')
      console.log "upadte alias"
      @model.set alias: @$('input').val()
