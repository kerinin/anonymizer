{Chunk} = require 'models/chunk'


class exports.Sample extends Backbone.Collection
  model: Chunk

  url: '/next'

  original_text: ->
    @models.map (chunk) ->
      chunk.get 'content'
    .join(' ')
