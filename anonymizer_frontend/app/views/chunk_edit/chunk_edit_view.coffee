chunkEditTemplate = require('./templates/chunk_edit')

class exports.ChunkEditView extends Backbone.View
  id: 'chunk_edit_view'

  events:
    'click #screen': 'cancelAndClose'
    'click .save': 'saveAndClose'
    'click .delete': 'deleteAndClose'
    #'submit': 'saveAndClose'
    #'click input:radio[name=type]': 'handleTypeChange'

  initialize: =>
    @router = @options['router']
    @model = @chunk = @options['chunk']
    @state = 'idle'

    @chunk.store()
    @chunk.bind 'change:type', @getMatches
    @chunk.bind 'all', @render
    @getMatches()
    KeyboardJS.bind.key 'esc', null, @cancelAndClose
    KeyboardJS.bind.key 'enter', null, @saveAndClose

  render: =>
    @$(@el).html chunkEditTemplate chunk: @chunk, state: @state

    Backbone.ModelBinding.bind(this, {all: "name"})
    this

  # This may still require some caching or refactoring
  getMatches: =>
    switch @chunk.get 'type'
      when 'set'
        @chunk.set type: 'glob', {silent: true}
        @chunk.getMatches @handleGetOptionsSuccess, @handleMatchesFailure
        @chunk.set type: 'set', {silent: true}
        @state = 'waiting'
      when 'glob', 'numeric', 'glob-excl'
        # This should be a different type?
        @chunk.getMatches @handleMatchesSuccess, @handleMatchesFailure
        @state = 'waiting'
      else
        @state = 'idle'
    @render()

  handleMatchesSuccess: (results) =>
    if results['regex'] == @chunk.collection.searchText()
      @chunk.set matches: results['results']
      @state = 'received'
      @render()
  
  handleGetOptionsSuccess: (results) =>
    if @chunk.get('type') == 'set'
      @chunk.set options: results['results']
      @state = 'received'
      @render()

  handleMatchesFailure: (results) =>
    console.log results
    @state = 'error'
    @render()

  saveAndClose: (e) =>
    console.log 'save and close'
    @unbind()
    @close()

  deleteAndClose: =>
    @chunk.set anonymize: false
    @close()

  cancelAndClose: =>
    console.log 'cancel and close'
    @chunk.restore()
    @close()

  close: =>
    KeyboardJS.unbind.key 'esc'
    KeyboardJS.unbind.key 'enter'
    @router.navigate("/edit", {trigger: true})  # NOTE: this is going to reset the sample
