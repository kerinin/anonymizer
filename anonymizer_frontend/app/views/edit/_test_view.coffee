{ResultView} = require 'views/edit/_result_view'
testTemplate = require './templates/_test'

class exports.TestView extends Backbone.View
  
  id: 'test'
  tagName: 'table'

  initialize: =>
    @router = @options['router']
    @sample = @options['sample']
    @test_results = @options['test_results']

    @sample.bind "all", @getTestResults
    @sample.bind "reset", @clear
    @test_results.bind 'add', @addOne
    @test_results.bind 'reset', @addAll

  render: =>
    @$(@el).replaceWith testTemplate
    this

  addOne: (test_result) =>
    view = new ResultView test_result: test_result
    @$(@el).append( view.render().el )

  addAll: =>
    @$(@el).empty()
    @test_results.models.forEach @addOne

  getTestResults: =>
    @sample.test()

  clear: =>
    @test_results.reset()
