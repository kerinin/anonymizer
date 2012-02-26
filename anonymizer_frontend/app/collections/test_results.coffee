{TestResult} = require 'models/test_result'

class exports.TestResults extends Backbone.Collection
  model: TestResult

  # Should be initialized with a redactor to bind with
  initialize: (redactor) =>
    # [idle,waiting,recieved,empty,error]
    @resultCount = null
    @state = 'idle'
    @redactor = redactor

    @redactor.get('chunks').bind 'all', @handleRedactorEvent

  handleRedactorEvent: =>
    if @redactor.length < 2
      if @state isnt 'idle'
        @resultCount = null
        @state = 'idle'
        @trigger('toIdle')
    else
      @testRedactor()

  testRedactor: =>
    @post
      search: @redactor.get('chunks').searchText(),
      replace: @redactor.get('chunks').replaceText()
    , "test_filter", @testCallback, @testFailback
    @resultCount = null
    @state = 'waiting'
    @trigger('toWaiting')

  testCallback: (results) =>
    # This conditional is a sanity check to ensure that we don't
    # end up with stale responses being shown
    if results['regex'] is "#{@redactor.get('chunks').searchText()}"
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

