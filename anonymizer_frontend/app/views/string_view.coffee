{ChunkView} = require 'views/chunk_view'

class exports.StringView extends Backbone.View

  initialize: ->
    app.sample.bind 'add', @addOne
    app.sample.bind 'reset', @addAll

  render: ->
    this

  addOne: (chunk) ->
    view = new ChunkView model: chunk
    @$("#string").append view.render().el

  addAll: =>
    $("#string").empty()
    app.sample.each @addOne
