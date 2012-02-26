{Chunk} = require 'models/chunk'


class exports.ChunkCollection extends Backbone.Collection
  model: Chunk

  url: '/next'

  initialize: =>
    @bind 'add', this.groupChunks
    @bind 'remove', this.groupChunks
    @bind 'change:anonymize', this.groupChunks

  originalText: =>
    @models.map (chunk) ->
      chunk.get 'content'
    .join()

  searchText: =>
    "^#{(chunk.searchText() for chunk in @models).filter(Boolean).join('')}$"

  replaceText: =>
    (chunk.replaceText() for chunk in @models).filter(Boolean).join('')

  groupChunks: =>
    [0..(@length-1)].forEach (i) =>
      if i>0 and @at(i-1) and @at(i) and !@at(i-1).get('anonymize') and !@at(i).get('anonymize')
        @at(i-1).set content: @at(i-1).get('content') + @at(i).get('content')
        @remove @at(i)

  parse: (response) =>
    @percentMatched = response['percent_matched']
    @filterCount = response['filter_count']
    response['chunks']
