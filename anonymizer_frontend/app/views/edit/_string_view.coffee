{ChunkView} = require 'views/edit/_chunk_view'

class exports.StringView extends Backbone.View

  initialize: =>
    @router = @options['router']
    @redactor = @options['redactor']
    @child_views = []

    @bind() if @options['bind'] isnt false

  bind: =>
    @redactor.bind 'all', @render

  unbind: =>
    @redactor.unbind 'all', @render

  remove: =>
    @unbind()
    view.remove() for view in @child_views
    @$(@el).remove()

  render: =>
    @remove()
    @redactor.get('chunks').forEach (chunk) =>
      view = new ChunkView chunk: chunk, router: @router, bind: @options['bind']
      @$(@el).append view.render().el
      @child_views.push view
    this

  remove: ->
    @$(@el).empty()
