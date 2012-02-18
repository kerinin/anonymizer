{Chunk} = require 'models/chunk'

class exports.ChunkView extends Backbone.View

  tagName: 'span'
  className: 'chunk'

  events: 
    'mouseup': 'handleMouseUp'

  initialize: =>
    @router = @options['router']
    @chunk = @options['chunk']

    @chunk.bind 'all', @render
    @chunk.bind 'remove', @remove
    @chunk.view = this

  render: =>
    @$(@el).text @chunk.get("content")
    if @chunk.get('anonymize')
      @$(@el).addClass('anonymize')
    else
      @$(@el).removeClass('anonymize')
    this

  handleMouseUp: =>
    if @chunk.get 'anonymize'
      #@toggleAnonymize()
      app.router.navigate("/edit/chunk/#{@chunk.index()}", {trigger: true})
      return false
    else
      @createChunk()

  toggleAnonymize: =>
    @chunk.toggleAnonymize()

  getRangeFromSelection: =>
    window.getSelection().getRangeAt(0)

  clearSelection: =>
    window.getSelection().empty()

  rangeCrossesChunks: (range) =>
    range.startContainer isnt range.endContainer

  getTextFromRange: (range) =>
    range.cloneContents().textContent

  getTextBeforeRange: (range) =>
    pre_range = range.cloneRange()
    pre_range.setStartBefore(range.startContainer)
    pre_range.setEnd(range.startContainer, range.startOffset)
    @getTextFromRange pre_range

  getTextAfterRange: (range) =>
    post_range = range.cloneRange()
    post_range.setEndAfter(range.endContainer)
    post_range.setStart(range.endContainer, range.endOffset)
    @getTextFromRange post_range
    
  createChunk: =>
    chunk_range = @getRangeFromSelection()

    if @rangeCrossesChunks(chunk_range)
      alert("NO! don't select the red bits")
    else
      pre = new Chunk content: @getTextBeforeRange(chunk_range)
      chunk = new Chunk content: @getTextFromRange(chunk_range), anonymize: true
      post = new Chunk content: @getTextAfterRange(chunk_range)

      @chunk.replaceWith( ( i for i in [pre,chunk,post] when i.get("content") isnt '') )
      @remove

  remove: =>
    @$(@el).remove()
