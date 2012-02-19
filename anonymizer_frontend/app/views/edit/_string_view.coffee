{ChunkView} = require 'views/edit/_chunk_view'

class exports.StringView extends Backbone.View

  initialize: =>
    @router = @options['router']
    @sample = @options['sample']

    @sample.bind 'all', @addAll

  render: =>
    @addAll()
    this

  addOne: (chunk) =>
    view = new ChunkView chunk: chunk, router: @router
    @$(@el).append view.render().el

  addAll: =>
    @remove()
    @sample.models.forEach @addOne

  remove: ->
    @$(@el).empty()
