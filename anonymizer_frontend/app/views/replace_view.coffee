{ChunkReplaceView} = require 'views/chunk_replace_view'
replaceTemplate = require './templates/replace'

class exports.ReplaceView extends Backbone.View
  id: "replace"

  initialize: ->
    @collection.bind 'all', @render

  render: =>
    @$(@el).html replaceTemplate sample: @collection
    @collection.models.forEach (chunk) =>
      view = new ChunkReplaceView model: chunk
      @$(@el).children("span").append view.render().el
    this
