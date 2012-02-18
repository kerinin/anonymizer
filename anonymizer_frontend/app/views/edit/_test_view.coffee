{ResultView} = require 'views/edit/_result_view'

testWaitingTemplate = require './templates/test/_waiting'
testEmptyTemplate = require './templates/test/_empty'
testErrorTemplate = require './templates/test/_error'

class exports.TestView extends Backbone.View
  
  id: 'test'
  tagName: 'table'

  initialize: =>
    @router = @options['router']
    @sample = @options['sample']
    @test_results = @options['test_results']

    @test_results.bind 'all', @render

  render: =>
    console.log "rendering test results in state #{@test_results.state}"
    @$(@el).empty()

    switch @test_results.state
      # when idle, do nothing
      when 'waiting'
        @$(@el).html testWaitingTemplate()
      when 'empty'
        @$(@el).html testEmptyTemplate()
      when 'error'
        @$(@el).html testErrorTemplate()
      when 'recieved'
        if @test_results.length == @test_results.resultCount
          @$(@el).append $("<tr><td class='count', colspan=3>#{@test_results.resultCount} matches found</td></tr>")
        else
          @$(@el).append $("<tr><td class='count', colspan=3>#{@test_results.resultCount} matches found, showing #{@test_results.length}</td></tr>")
        @test_results.models.forEach (test_result) =>
          view = new ResultView test_result: test_result
          @$(@el).append view.render().el

    this
