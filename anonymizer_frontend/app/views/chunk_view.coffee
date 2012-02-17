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

  createChunk: ->
    selection = window.getSelection()
    chunk_range = selection.getRangeAt(0)
    
    if chunk_range.startContainer isnt chunk_range.endContainer
      # selection crosses an anonymized chunk (or worse)
      #
      alert("NO! don't select the red bits")
    else
      pre_range = chunk_range.cloneRange()
      pre_range.setStartBefore(chunk_range.startContainer)
      pre_range.setEnd(chunk_range.startContainer, chunk_range.startOffset)
      
      post_range = chunk_range.cloneRange()
      post_range.setEndAfter(chunk_range.endContainer)
      post_range.setStart(chunk_range.endContainer, chunk_range.endOffset)

      pre = new Chunk content: pre_range.cloneContents().textContent
      chunk = new Chunk content: chunk_range.cloneContents().textContent, anonymize: true
      post = new Chunk content: post_range.cloneContents().textContent

      chunkIndex = @model.collection.models.indexOf(@model)
      collection = @model.collection
      collection.add ( item for item in [pre,chunk,post] when item.get("content") isnt '' )
      collection.remove(@model)
      collection.groupChunks()
      @remove

    selection.empty()

  remove: ->
    $(@el).remove()
