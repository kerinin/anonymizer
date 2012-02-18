{EditView} = require 'views/edit/edit_view'
{ChunkEditView} = require 'views/chunk_edit/chunk_edit_view'

class exports.MainRouter extends Backbone.Router
  routes :
    '': 'edit'
    '/edit/chunk/:id': 'chunk_edit'
    '/edit': 'edit'

  edit: ->
    view = new EditView
    $('body').empty()
    $('body').html view.render().el
    app.sample.fetch()

  chunk_edit: (id) ->
    # Make sure the requested chunk can be edited
    if not app.sample or app.sample.length < id or not app.sample.at(id).get("anonymize")
      @navigate("/edit", {trigger: true})
    else
      baseView = new EditView
      view = new ChunkEditView model: app.sample.at(id)

      # This view is intended to be a 'pop-up', so render the 'base view'
      # for context, then render this view
      $('body').empty()
      $('body').html baseView.render().el
      $('body').append view.render().el
