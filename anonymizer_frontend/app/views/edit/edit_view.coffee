{StringView} = require 'views/edit/_string_view'
{FilterView} = require 'views/edit/_filter_view'
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

    @stringView = new StringView sample: @sample, router: @router, bind: @options['bind']
    @filterView = new FilterView sample: @sample, router: @router, bind: @options['bind']
    @testView = new TestView test_results: @test_results, sample: @sample, router: @router, bind: @options['bind']

    @child_views = [@stringView, @filterView, @testView]

    @bind() if @options['bind'] isnt false

  bind: =>
    @sample.bind 'all', @render
    KeyboardJS.bind.key 'esc', null, @resetString
    KeyboardJS.bind.key 'enter', null, @saveString
    KeyboardJS.bind.key 'right,space', null, @nextString

  unbind: =>
    @sample.unbind 'all', @render
    KeyboardJS.unbind.key 'esc'
    KeyboardJS.unbind.key 'enter'
    KeyboardJS.unbind.key 'right,space'
    
  remove: =>
    @unbind()
    view.remove for view in @child_views
    @$(@el).remove()

  render: =>
    $(@el).html editTemplate sample: @sample
    
    @$('#string').html( @stringView.render().el )
    @$('#filter').replaceWith( @filterView.render().el )
    @$('#test').replaceWith( @testView.render().el )

    this

  resetString: =>
    @sample.get('chunks').forEach (chunk) ->
      chunk.set anonymize: false
      chunk.set collapse: false

    return false

  nextString: =>
    @router.navigate("/new", {trigger: true})
  
  saveString: =>
    @sample.save()
    @sample.fetch()

    return false
