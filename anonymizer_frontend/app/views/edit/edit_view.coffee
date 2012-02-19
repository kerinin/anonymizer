{StringView} = require 'views/edit/_string_view'
{SearchView} = require 'views/edit/_search_view'
{ReplaceView} = require 'views/edit/_replace_view'
{TestView} = require 'views/edit/_test_view'
editTemplate = require('./templates/edit')

class exports.EditView extends Backbone.View
  id: 'home-view'
  tagName: 'form'

  events:
    "click #reset": "resetString"
    "click #save": "saveString"
    "submit": "saveString"


  initialize: =>
    @router = @options['router']
    @sample = @options['sample']
    @test_results = @options['test_results']

    @stringView = new StringView sample: @sample, router: @router
    @searchView = new SearchView sample: @sample, router: @router
    @replaceView = new ReplaceView sample: @sample, test_results: @test_results, router: @router
    @testView = new TestView test_results: @test_results, sample: @sample, router: @router

    @sample.bind 'reset', @render

  render: =>
    $(@el).html editTemplate sample: @sample
    
    @$('#string').html( @stringView.render().el )
    @$('#search').html( @searchView.render().el )
    @$('#replace').replaceWith( @replaceView.render().el )
    @$('#test').replaceWith( @testView.render().el )

    this

  resetString: =>
    @sample.models.forEach (chunk) ->
      chunk.set anonymize: false
      chunk.set collapse: false

    return false

  nextString: =>
    @sample.fetch()

    return false
  
  saveString: =>
    @sample.save()
    @sample.fetch()

    return false
