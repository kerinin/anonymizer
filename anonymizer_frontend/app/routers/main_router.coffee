{CreateView} = require 'views/create/create_view'
{ChunkEditView} = require 'views/chunk_edit/chunk_edit_view'

class exports.MainRouter extends Backbone.Router
  routes :
    '': 'create'
    '/create': 'create'
    '/edit/chunk/:id': 'chunk_edit'

  create: ->
    view = new CreateView
    $('body').empty()
    $('body').html view.render().el
    app.sample.fetch()

  chunk_edit: (id) ->
    # Make sure the requested chunk can be edited
    if not app.sample or app.sample.length < id or not app.sample.at(id).get("anonymize")
      @navigate("/create", {trigger: true})
    else
      baseView = new CreateView
      view = new ChunkEditView

      # This view is intended to be a 'pop-up', so render the 'base view'
      # for context, then render this view
      $('body').empty()
      $('body').html baseView.render().el
      $('body').append view.render().el
