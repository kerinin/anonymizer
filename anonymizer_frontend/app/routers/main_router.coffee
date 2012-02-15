class exports.MainRouter extends Backbone.Router
  routes :
    '': 'home'
    'next': 'home'

  home: ->
    $('body').html app.homeView.render().el
    app.sample.fetch()
