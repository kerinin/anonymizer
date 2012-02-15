class exports.HomeView extends Backbone.View
  id: 'home-view'

  events:
    "click #reset": "resetString"
    "click #next": "nextString"

  render: ->
    $(@el).html require('./templates/home')
    
    $(@el).find('#string').empty()
    $(@el).find('#string').html( app.views.stringView.render().el )
    $(@el).find('#search').html( app.views.searchView.render().el )
    $(@el).find('#replace').html( app.views.replaceView.render().el )
    this

  resetString: ->
    app.sample.models.forEach (chunk) ->
      chunk.set anonymize: false
      chunk.set collapse: false

    return false

  nextString: ->
    app.sample.reset()
    app.sample.fetch()

    return false
