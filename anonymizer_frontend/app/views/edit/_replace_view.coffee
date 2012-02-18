{ChunkReplaceView} = require 'views/edit/_chunk_replace_view'

class exports.ReplaceView extends Backbone.View
  id: "replace"

  initialize: =>
    @router = @options['router']
    @sample = @options['sample']

    @sample.bind 'all', @render

  render: =>
    @$(@el).html '<span>'
    @sample.models.forEach (chunk) =>
      view = new ChunkReplaceView chunk: chunk
      @$(@el).children("span").append view.render().el
    this
