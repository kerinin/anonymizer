chunkReplaceTemplate = require './templates/_replace_chunk'

class exports.ChunkReplaceView extends Backbone.View
  tagName: 'span'

  events:
    'blur input': 'updateAlias'

  initialize: ->
    @router = @options['router']
    @chunk = @options['chunk']

    @tagName = (if @chunk.get('anonymize') then 'input' else 'span')
    @chunk.bind 'all', @render

  render: =>
    @$(@el).html chunkReplaceTemplate chunk: @chunk
    this

  updateAlias: ->
    if @chunk.get('anonymize')
      @chunk.set alias: @$('input').val()
