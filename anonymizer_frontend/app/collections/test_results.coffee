{TestResult} = require 'models/test_result'

class exports.TestResults extends Backbone.Collection
  model: TestResult

  # Should be initialized with a sample to bind with
  initialize: (sample) =>
    # [idle,waiting,recieved,empty,error]
    @resultCount = null
    @state = 'idle'
    @sample = sample

    @sample.bind 'all', @handleSampleEvent

  handleSampleEvent: =>
    if @sample.length < 2
      if @state isnt 'idle'
        @resultCount = null
        @state = 'idle'
        @trigger('toIdle')
    else
      @testSample()

  testSample: =>
    @post
      search: @sample.searchText(),
      replace: @sample.replaceText()
    , "test_filter", @testCallback, @testFailback
    @resultCount = null
    @state = 'waiting'
    @trigger('toWaiting')

  testCallback: (results) =>
    # This conditional is a sanity check to ensure that we don't
    # end up with stale responses being shown
    if results['regex'] is "#{@sample.searchText()}"
      @reset(results['results'], {silent: true})
      @resultCount = results['total']

      if @length == 0
        @state = 'empty'
        @trigger('toEmpty')
      else
        @state = 'recieved'
        @trigger('toRecieved')

  testFailback: (results) =>
    console.log results
    @resultsCount = null
    @state = 'error'
    @trigger('toError')

  post: (data, url, callback, failback) ->
    $.ajax
      type: "POST",
      url: url,
      data: JSON.stringify(data),
      contentType: "application/json; charset=utf-8",
      dataType: "json",
      success: callback,
      failure: failback

