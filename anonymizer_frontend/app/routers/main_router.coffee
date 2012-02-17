{CreateView} = require 'views/create/create_view'

class exports.MainRouter extends Backbone.Router
  routes :
    '': 'create'
    'create': 'create'

  create: ->
    view = new CreateView
    $('body').html view.render().el
    app.sample.fetch()
