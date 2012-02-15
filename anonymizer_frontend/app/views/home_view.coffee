class exports.HomeView extends Backbone.View
  id: 'home-view'

  render: ->
    $(@el).html require('./templates/home')
    
    $(@el).find('#string').html( app.views.stringView.render().el )
    this

