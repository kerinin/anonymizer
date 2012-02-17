{Chunk} = require 'models/chunk'


class exports.Sample extends Backbone.Collection
  model: Chunk

  url: '/next'

  initialize: =>
    @bind 'add', this.groupChunks
    @bind 'remove', this.groupChunks
    @bind 'change:anonymize', this.groupChunks

  originalText: ->
    @models.map (chunk) ->
      chunk.get 'content'
    .join()

  searchText: ->
    "^#{(chunk.searchText() for chunk in @models).filter(Boolean).join('')}$"

  replaceText: ->
    (chunk.replaceText() for chunk in @models).filter(Boolean).join('')

  groupChunks: =>
    [0..(@length-1)].forEach (i) =>
      if i>0 and @at(i-1) and @at(i) and @at(i-1).get('anonymize') is @at(i).get('anonymize')
        @at(i-1).set content: @at(i-1).get('content') + @at(i).get('content')
        @remove @at(i)

  save: ->
    @post 
      search: @searchText(),
      replace: @replaceText()
    , "filters"

  test: ->
    @post
      search: @searchText(),
      replace: @replaceText()
    , "test_filter", @testCallback

  testCallback: (results) =>
    # This conditional is a sanity check to ensure that we don't
    # end up with stale responses being shown
    if results['regex'] is "#{@searchText()}"
      app.test_results.reset(results['results'])

  testFailback: (results) ->
    console.log(results)

  post: (data, url, callback, failback) ->
    $.ajax
      type: "POST",
      url: url,
      data: JSON.stringify(data),
      contentType: "application/json; charset=utf-8",
      dataType: "json",
      success: callback,
      failure: failback

