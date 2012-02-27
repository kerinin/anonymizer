{OptionsView} = require('views/chunk_edit/_options_view')
{MatchesView} = require('views/chunk_edit/_matches_view')
chunkEditTemplate = require('./templates/chunk_edit')

class exports.ChunkEditView extends Backbone.View
  id: 'chunk_edit_view'

  events:
    'click #screen': 'cancelAndClose'
    'click .save': 'saveAndClose'
    'click .delete': 'deleteAndClose'

  initialize: =>
    @router = @options['router']
    @model = @chunk = @options['chunk']

    @chunk.store()
    @bind() if @options['bind'] isnt false

  bind: =>
    @chunk.bind 'change:type', @render
    KeyboardJS.bind.key 'esc', null, @cancelAndClose
    KeyboardJS.bind.key 'enter', null, @saveAndClose

  unbind: =>
    @chunk.unbind 'change:type', @render
    KeyboardJS.unbind.key 'esc'
    KeyboardJS.unbind.key 'enter'

  remove: =>
    @unbind()
    view.remove() for view in @child_views
    @$(@el).remove()

  render: =>
    @$(@el).html chunkEditTemplate chunk: @chunk, state: @state
    Backbone.ModelBinding.bind(this, {all: "name"})
    switch @chunk.get 'type'
      when 'set'
        view = new OptionsView chunk: @chunk, router: @router, bind: @options['bind']
        @child_views = [view]
        @$("#ajax").replaceWith view.render().el
      when 'glob', 'numeric', 'glob-excl'
        view = new MatchesView chunk: @chunk, router: @router, bind: @options['bind']
        @child_views = [view]
        @$("#ajax").replaceWith view.render().el
    this

  saveAndClose: (e) =>
    @unbind()
    @close()

  deleteAndClose: =>
    @chunk.set anonymize: false
    @close()

  cancelAndClose: =>
    @chunk.restore()
    @close()

  close: =>
    @router.navigate("/edit", {trigger: true})  # NOTE: this is going to reset the redactor
