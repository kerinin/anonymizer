{ChunkReplaceView} = require 'views/edit/_chunk_replace_view'

class exports.ReplaceView extends Backbone.View
  id: "replace"

  events:
    'blur input': 'handleBlur'

  initialize: =>
    @router = @options['router']
    @sample = @options['sample']
    @test_results = @options['test_results']

    @sample.bind 'all', @render

  render: =>
    @$(@el).html '<span class="label">redact with:</span> <span class="console"></span'
    @sample.models.forEach (chunk) =>
      view = new ChunkReplaceView chunk: chunk
      @$(@el).children("span:last").append view.render().el
    this

  handleBlur: =>
    if not @$(':focus').length
      @test_results.testSample()
