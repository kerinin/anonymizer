resultTemplate = require './templates/_result'

class exports.ResultView extends Backbone.View

  tagName: 'tr'

  initialize: =>
    @router = @options['router']
    @test_result = @options['test_result']

    @bind() if @options['bind'] isnt false

  bind: =>
    @test_result.bind 'all', @render

  unbind: =>
    @test_result.unbind 'all', @render

  remove: =>
    @unbind()
    @$(@el).remove()

  render: =>
    @$(@el).html resultTemplate test_result: @test_result
    this
