{RedactorCollection} = require 'collections/redactor_collection'
{Redactor} = require 'models/redactor'

class exports.RedactionScope extends Backbone.RelationalModel
  relations:
    [{
      type: Backbone.HasMany
      key: 'redactors'
      relatedModel: Redactor
      collectionType: RedactorCollection
      reverseRelation:
        key: 'scope'
    }]
    
  defaults:
    scope: null
    percent_matched: null
