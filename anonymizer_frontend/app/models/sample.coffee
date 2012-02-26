{Chunk} = require 'models/chunk'
{ChunkCollection} = require 'collections/chunk_collection'

class exports.Sample extends Backbone.RelationalModel

  relations:
    [{
      type: Backbone.HasMany
      key: 'chunks'
      relatedModel: Chunk
      collectionType: ChunkCollection
      reverseRelation:
        key: 'sample'
    }]
