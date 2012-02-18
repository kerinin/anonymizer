{StringView} = require 'views/edit/_string_view'
{SearchView} = require 'views/edit/_search_view'
{ReplaceView} = require 'views/edit/_replace_view'
{TestView} = require 'views/edit/_test_view'

class exports.EditView extends Backbone.View
  id: 'home-view'

  events:
    "click #reset": "resetString"
    "click #next": "nextString"
    "click #save": "saveString"


  initialize: ->
    @stringView = new StringView model: app.sample
    @searchView = new SearchView model: app.sample
    @replaceView = new ReplaceView collection: app.sample
    @testView = new TestView collection: app.test_results

  render: ->
    $(@el).html require('./templates/edit')
    
    @$('#string').html( @stringView.render().el )
    @$('#search').html( @searchView.render().el )
    @$('#replace').replaceWith( @replaceView.render().el )
    @$('#test').replaceWith( @testView.render().el )

    this

  resetString: ->
    app.sample.models.forEach (chunk) ->
      chunk.set anonymize: false
      chunk.set collapse: false

    return false

  nextString: ->
    app.sample.fetch()

    return false
  
  saveString: ->
    app.sample.save()
    app.sample.fetch()

    return false
