chunkEditTemplate = require('./templates/chunk_edit')

class exports.ChunkEditView extends Backbone.View
  id: 'chunk_edit_view'
  tagName: 'form'

  events:
    'click': 'noOp'
    'click .save': 'saveAndClose'
    'click .cancel': 'close'
    'submit': 'saveAndClose'
    'click input:radio[name=type]': 'handleTypeChange'


  initialize: =>
    @router = @options['router']
    @chunk = @options['chunk']
    @type = @chunk.get "type"
    @options = @chunk.get "options"
    @optional = @chunk.get "optional"
    @pass_through = @chunk.get "pass_through"
    @state = 'idle'

  render: =>
    console.log "rendering edit view"
    @$(@el).html chunkEditTemplate type: @type, options: @options, state: @state
    @$("input:radio[name=type][value=#{@type}]").attr("checked", true)
    @$("input[name=optional]").attr("checked", @optional)
    @$("input[name=pass_through]").attr("checked", @pass_through)
    this

  safeRender: =>
    @type = @getType()
    @optional = @getOptional()
    @pass_through = @getPassThrough()
    @render()

  handleTypeChange: =>
    @type = @getType()
    switch @type
      when 'set', 'char-set'
        @chunk.getOptionsFor @getType(), @handleGetOptionsSuccess, @handleGetOptionsFail
        @state = 'waiting'
      else
        @state = 'idle'
    @safeRender()

  handleGetOptionsSuccess: (results) =>
    console.log "options callback #{results['results']}"
    console.log "type: #{@type}"
    @options = results['results']
    @state = 'received'
    @safeRender()

  handleGetOptionsFail: (results) =>
    console.log results
    @state = 'error'
    @safeRender()

  setType: =>
    @chunk.set type: @type

  setOptional: =>
    @chunk.set optional: @getOptional()

  setPassThrough: =>
    @chunk.set pass_through: @getPassThrough()

  setOptions: =>
    @chunk.set options: @options

  saveAndClose: =>
    @setType()
    @setOptional()
    @setPassThrough()
    @setOptions()
    @close()

  close: =>
    @router.navigate("/edit", {trigger: true})  # NOTE: this is going to reset the sample

  noOp: =>

  getType: =>
    @$('input[name=type]:checked').val()

  getOptional: =>
    @$('input[name=optional]').is(":checked")

  getPassThrough: =>
    @$('input[name=pass_through]').is(":checked")
