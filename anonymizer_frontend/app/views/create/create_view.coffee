class exports.CreateView extends Backbone.View
  id: 'home-view'

  events:
    "click #reset": "resetString"
    "click #next": "nextString"
    "click #save": "saveString"


  render: ->
    $(@el).html require('./templates/create')
    
    @$('#string').html( app.views.stringView.render().el )
    @$('#search').html( app.views.searchView.render().el )
    @$('#replace').replaceWith( app.views.replaceView.render().el )
    @$('#test').replaceWith( app.views.testView.render().el )
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
