resultTemplate = require './templates/_result'

class exports.ResultView extends Backbone.View

  tagName: 'tr'

  initialize: ->
    @router = @options['router']
    @test_result = @options['test_result']

    @test_result.bind 'all', @render

  render: =>
    @$(@el).html resultTemplate test_result: @test_result
    this
