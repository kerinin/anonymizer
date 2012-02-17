{Chunk} = require 'models/chunk'
chunkTemplate = require './templates/chunk'

class exports.ChunkView extends Backbone.View

  tagName: 'span'
  className: 'chunk'

  events: 
    'mouseup': 'handleMouseUp'

  initialize: ->
    @model.bind 'all', @render
    @model.bind 'remove', @remove
    @model.view = this

  render: =>
    @$(@el).text @model.get("content")
    if @model.get('anonymize')
      @$(@el).addClass('anonymize')
    else
      @$(@el).removeClass('anonymize')

    this

  handleMouseUp: ->
    if @model.get 'anonymize'
      @toggleAnonymize()
    else
      @createChunk()

  toggleAnonymize: ->
    @model.toggleAnonymize()

  getRangeFromSelection: ->
    window.getSelection().getRangeAt(0)

  clearSelection: ->
    window.getSelection().empty()

  rangeCrossesChunks: (range) ->
    range.startContainer isnt range.endContainer

  getTextFromRange: (range) ->
    range.cloneContents().textContent

  getTextBeforeRange: (range) ->
    pre_range = range.cloneRange()
    pre_range.setStartBefore(range.startContainer)
    pre_range.setEnd(range.startContainer, range.startOffset)
    @getTextFromRange pre_range

  getTextAfterRange: (range) ->
    post_range = range.cloneRange()
    post_range.setEndAfter(range.endContainer)
    post_range.setStart(range.endContainer, range.endOffset)
    @getTextFromRange post_range
    
  createChunk: ->
    chunk_range = @getRangeFromSelection()

    if @rangeCrossesChunks(chunk_range)
      alert("NO! don't select the red bits")
    else
      pre = new Chunk content: @getTextBeforeRange(chunk_range)
      chunk = new Chunk content: @getTextFromRange(chunk_range), anonymize: true
      post = new Chunk content: @getTextAfterRange(chunk_range)

      @model.replaceWith( ( i for i in [pre,chunk,post] when i.get("content") isnt '') )
      @remove

  remove: ->
    $(@el).remove()
