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

    view = new NewView(redactor: app.redactor, router: this)
    $('body').html view.render().el
    app.redactor.get('chunks').fetch()

    app.current_views = [view]
    _gaq.push(['_trackEvent', 'Route', 'Load', 'New']);

  edit: =>
    if app.redactor.get('chunks').length == 0
      @navigate("/new", {trigger: true})
    else
      view.remove() for view in app.current_views

      view = new EditView redactor: app.redactor, test_results: app.test_results, router: this
      $('body').empty()
      $('body').html view.render().el

      app.current_views = [view]
      _gaq.push(['_trackEvent', 'Route', 'Load', 'Edit']);

  chunk_edit: (id) =>
    # Make sure the requested chunk can be edited
    if not app.redactor or not app.redactor.get('chunks').at(id) or not app.redactor.get('chunks').at(id).get("anonymize")
      @navigate("/edit", {trigger: true})
    else
      view.remove() for view in app.current_views

      baseView = new EditView redactor: app.redactor, test_results: app.test_results, router: this, bind: false
      view = new ChunkEditView chunk: app.redactor.get('chunks').at(id), router: this

      # This view is intended to be a 'pop-up', so render the 'base view'
      # for context, then render this view
      $('body').empty()
      $('body').html view.render().el
      $('body').append baseView.render().el
      $("#chunk_edit_view input[name=alias]").select()

      app.current_views = [baseView,view]
      _gaq.push(['_trackEvent', 'Route', 'Load', 'ChunkEdit']);
