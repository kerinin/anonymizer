chunkEditTemplate = require('./templates/chunk_edit')
viewStateMatchesTemplate = require('./templates/_state_matches')
viewStateOptionsTemplate = require('./templates/_state_options')

class exports.ChunkEditView extends Backbone.View
  id: 'chunk_edit_view'

  events:
    'click #screen': 'cancelAndClose'
    'click .save': 'saveAndClose'
    'click .delete': 'deleteAndClose'

  initialize: =>
    @router = @options['router']
    @model = @chunk = @options['chunk']
    @state = 'idle'

    @chunk.store()
    @getMatches()
    @bind() if @options['bind'] isnt false

  bind: =>
    @chunk.bind 'change:type', @getMatches
    KeyboardJS.bind.key 'esc', null, @cancelAndClose
    KeyboardJS.bind.key 'enter', null, @saveAndClose

  unbind: =>
    @chunk.unbind 'change:type'
    @chunk.unbind 'all'
    KeyboardJS.unbind.key 'esc'
    KeyboardJS.unbind.key 'enter'

  remove: =>
    @unbind()

  render: =>
    @$(@el).html chunkEditTemplate chunk: @chunk, state: @state
    Backbone.ModelBinding.bind(this, {all: "name"})
    @renderViewState()
    this

  renderViewState: =>
    switch @chunk.get('type')
      when 'set', 'char-set' 
        @$('#ajax').html viewStateOptionsTemplate(chunk: @chunk, state: @state)
      when 'glob', 'glob-excl', 'numeric' 
        @$('#ajax').html viewStateMatchesTemplate(chunk: @chunk, state: @state)

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
      focus_cache = @$(':focus')
      @chunk.set matches: results['results']
      @state = 'received'
      @renderViewState()
      focus_cache.select()
  
  handleGetOptionsSuccess: (results) =>
    if @chunk.get('type') == 'set'
      focus_cache = @(':focus')
      @chunk.set options: results['results']
      @state = 'received'
      @renderViewState()
      focus_cache.select()

  handleMatchesFailure: (results) =>
    @state = 'error'
    @renderViewState()

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
