optionsTemplate = require('./templates/_options')

class exports.OptionsView extends Backbone.View
  id: 'ajax'
  
  initialize: =>
    @router = @options['router']
    @model = @chunk = @options['chunk']
    @state = 'idle'

    @bind() if @options['bind'] isnt false
    @handleTypeChange()

  bind: =>
    @chunk.bind 'change:type', @handleTypeChange

  unbind: =>
    @chunk.unbind 'change:type', @handleTypeChange

  remove: =>
    @unbind()

  render: =>
    @$(@el).html optionsTemplate(chunk: @chunk, state: @state)
    Backbone.ModelBinding.bind(this, {all: "name"})
    this
    
  handleTypeChange: =>
    if @chunk.get('options').length < 1
      @getOptions()
    
  getOptions: =>
    @chunk.set type: 'glob', {silent: true}
    @chunk.getMatches @handleGetOptionsSuccess, @handleGetOptionsFailure
    @chunk.set type: 'set', {silent: true}
    @state = 'waiting'
    @render()
 
  handleGetOptionsSuccess: (results) =>
    if @chunk.get('type') == 'set'
      @chunk.set options: results['results']
      @chunk.set matches: results['results']
      @state = 'received'
      @render()

  handleGetOptionsFailure: (results) =>
    @state = 'error'
    @render()
