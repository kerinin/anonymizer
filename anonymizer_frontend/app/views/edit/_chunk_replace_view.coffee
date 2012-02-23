chunkReplaceTemplate = require './templates/_replace_chunk'

class exports.ChunkReplaceView extends Backbone.View
  tagName: 'span'

  events:
    'blur input': 'updateAlias'

  initialize: =>
    @router = @options['router']
    @chunk = @options['chunk']

    @tagName = (if @chunk.get('anonymize') then 'input' else 'span')
    @bind() if @options['bind'] isnt false

  bind: =>
    @chunk.bind 'all', @render

  unbind: =>
    @chunk.unbind 'all'

  remove: =>
    @unbind()
    @$(@el).remove()
    
  render: =>
    @$(@el).html chunkReplaceTemplate chunk: @chunk
    this

  updateAlias: =>
    if @chunk.get('anonymize')
      @chunk.set alias: @$('input').val(), {silent: true}
