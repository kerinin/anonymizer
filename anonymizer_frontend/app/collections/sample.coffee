{Chunk} = require 'models/chunk'


class exports.Sample extends Backbone.Collection
  model: Chunk

  url: '/next'

  originalText: ->
    @models.map (chunk) ->
      chunk.get 'content'
    .join()

  searchText: ->
    (chunk.searchText() for chunk in @models).filter(Boolean).join('')

  replaceText: ->
    (chunk.replaceText() for chunk in @models).filter(Boolean).join('')

  groupChunks: ->
    prev = false
    @models.forEach (chunk) ->
      if chunk.get 'anonymize'
        if prev
          chunk.set collapse: true
        else
          chunk.set collapse: false
        prev = true
      else
        prev = false

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

