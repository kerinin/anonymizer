{NewView} = require 'views/new/new_view'
{EditView} = require 'views/edit/edit_view'
{ChunkEditView} = require 'views/chunk_edit/chunk_edit_view'

class exports.MainRouter extends Backbone.Router
  routes :
    '': 'new'
    '/edit/chunk/:id': 'chunk_edit'
    '/edit': 'edit'
    '/new': 'new'

  new: =>
    view.remove() for view in app.current_views

    view = new NewView(collection: app.sample, router: this)
    $('body').html view.render().el
    app.sample.fetch()

    app.current_views = [view]

  edit: =>
    if app.sample.length == 0
      @navigate("/new", {trigger: true})
    else
      view.remove() for view in app.current_views

      view = new EditView sample: app.sample, test_results: app.test_results, router: this
      $('body').empty()
      $('body').html view.render().el

      app.current_views = [view]

  chunk_edit: (id) =>
    # Make sure the requested chunk can be edited
    if not app.sample or not app.sample.at(id) or not app.sample.at(id).get("anonymize")
      @navigate("/edit", {trigger: true})
    else
      view.remove() for view in app.current_views

      baseView = new EditView sample: app.sample, test_results: app.test_results, router: this
      baseView.unbindKeys()
      view = new ChunkEditView chunk: app.sample.at(id), router: this

      # This view is intended to be a 'pop-up', so render the 'base view'
      # for context, then render this view
      $('body').empty()
      $('body').html view.render().el
      $('body').append baseView.render().el

      app.current_views = [baseView,view]
