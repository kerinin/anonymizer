{Chunk} = require 'models/chunk'


class exports.Sample extends Backbone.Collection
  model: Chunk

  url: '/next'

  originalText: ->
    @models.map (chunk) ->
      chunk.get 'content'
    .join(' ')

  searchText: ->
    "/#{(chunk.searchText() for chunk in @models).join(' ')}/"

  replaceText: ->
    "\"#{(chunk.replaceText() for chunk in @models).join(' ')}\""

  groupChunks: ->
    prev = false
    @models.forEach (chunk) ->
      if chunk.get 'anonymize'
        if prev
          chunk.set collapse: true
        else
          chunk.set collapse: false
        prev = true
      else
        prev = false
