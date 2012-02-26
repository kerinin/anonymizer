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
    @redactor = @options['redactor']
    @test_results = @options['test_results']

    @stringView = new StringView redactor: @redactor, router: @router, bind: @options['bind']
    @filterView = new FilterView redactor: @redactor, router: @router, bind: @options['bind']
    @testView = new TestView test_results: @test_results, redactor: @redactor, router: @router, bind: @options['bind']

    @child_views = [@stringView, @filterView, @testView]

    @bind() if @options['bind'] isnt false

  bind: =>
    @redactor.bind 'all', @render
    KeyboardJS.bind.key 'esc', null, @resetString
    KeyboardJS.bind.key 'enter', null, @saveString
    KeyboardJS.bind.key 'right,space', null, @nextString

  unbind: =>
    @redactor.unbind 'all', @render
    KeyboardJS.unbind.key 'esc'
    KeyboardJS.unbind.key 'enter'
    KeyboardJS.unbind.key 'right,space'
    
  remove: =>
    @unbind()
    view.remove for view in @child_views
    @$(@el).remove()

  render: =>
    $(@el).html editTemplate redactor: @redactor
    
    @$('#string').html( @stringView.render().el )
    @$('#filter').replaceWith( @filterView.render().el )
    @$('#test').replaceWith( @testView.render().el )

    this

  resetString: =>
    @redactor.get('chunks').forEach (chunk) ->
      chunk.set anonymize: false
      chunk.set collapse: false

    return false

  nextString: =>
    @router.navigate("/new", {trigger: true})
  
  saveString: =>
    @redactor.save()
    @redactor.fetch()

    return false
