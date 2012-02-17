class exports.MainRouter extends Backbone.Router
  routes :
    '': 'create'
    'create': 'create'

  create: ->
    $('body').html app.createView.render().el
    app.sample.fetch()
