{ChunkView} = require 'views/chunk_view'

class exports.StringView extends Backbone.View

  initialize: ->
    app.sample.bind 'add', @addOne
    app.sample.bind 'reset', @addAll

  render: ->
    console.log("rendering string view")
    this

  addOne: (chunk) ->
    console.log("adding a chunk")
    view = new ChunkView model: chunk
    @$("#string").append view.render().el

  addAll: =>
    console.log("adding all chunks")
    $("#string").empty()
    app.sample.each @addOne
