{Chunk} = require 'models/chunk'
{ChunkCollection} = require 'collections/chunk_collection'

class exports.Redactor extends Backbone.RelationalModel

  relations:
    [{
      type: Backbone.HasMany
      key: 'chunks'
      relatedModel: Chunk
      collectionType: ChunkCollection
      reverseRelation:
        key: 'redactor'
    }]

  save: ->
    @post 
      search: @get('chunks').searchText(),
      replace: @get('chunks').replaceText(),
      chunks: @get('chunks').toJSON()
    , "filters"

  post: (data, url, callback, failback) ->
    $.ajax
      type: "POST",
      url: url,
      data: JSON.stringify(data),
      contentType: "application/json; charset=utf-8",
      dataType: "json",
      success: callback,
      failure: failback
