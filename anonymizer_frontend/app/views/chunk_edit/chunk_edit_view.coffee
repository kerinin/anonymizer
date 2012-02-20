chunkEditTemplate = require('./templates/chunk_edit')

class exports.ChunkEditView extends Backbone.View
  id: 'chunk_edit_view'

  events:
    'click #screen': 'cancelAndClose'
    'click .save': 'saveAndClose'
    'click .delete': 'deleteAndClose'
    'submit': 'saveAndClose'
    'click input:radio[name=type]': 'handleTypeChange'

  initialize: =>
    @router = @options['router']
    @model = @chunk = @options['chunk']
    @state = 'idle'

    @chunk.store()

  render: =>
    @$(@el).html chunkEditTemplate chunk: @chunk

    Backbone.ModelBinding.bind(this, {all: "name"})
    this

  # This may still require some caching or refactoring
  handleTypeChange: =>
    switch @chunk.get 'type'
      when 'set', 'char-set'
        # This should be a different type?
        @chunk.getOptionsFor @chunk.get('type'), @handleGetOptionsSuccess, @handleGetOptionsFail
        @state = 'waiting'
      else
        @state = 'idle'
    @render()

  handleGetOptionsSuccess: (results) =>
    @options = results['results']
    @state = 'received'
    @render()

  handleGetOptionsFail: (results) =>
    console.log results
    @state = 'error'
    @render()

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
    @router.navigate("/edit", {trigger: true})  # NOTE: this is going to reset the sample
