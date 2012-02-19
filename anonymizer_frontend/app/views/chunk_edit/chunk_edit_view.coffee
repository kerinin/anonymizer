chunkEditTemplate = require('./templates/chunk_edit')

class exports.ChunkEditView extends Backbone.View
  id: 'chunk_edit_view'
  tagName: 'form'

  events:
    'click #screen': 'close'
    'click .save': 'saveAndClose'
    'click .delete': 'deleteAndClose'
    'submit': 'saveAndClose'
    'click input:radio[name=type]': 'handleTypeChange'

  initialize: =>
    @router = @options['router']
    @chunk = @options['chunk']
    @type = @chunk.get "type"
    @options = @chunk.get "options"
    @optional = @chunk.get "optional"
    @pass_through = @chunk.get "pass_through"
    @alias = @chunk.get "alias"
    @state = 'idle'

    $('body').keypress @handleKeypress

  render: =>
    @$(@el).html chunkEditTemplate type: @type, options: @options, state: @state, alias: @alias
    @$("input:radio[name=type][value=#{@type}]").attr("checked", true)
    @$("input[name=optional]").attr("checked", @optional)
    @$("input[name=pass_through]").attr("checked", @pass_through)
    this

  safeRender: =>
    @type = @getType()
    @optional = @getOptional()
    @pass_through = @getPassThrough()
    @alias = @getAlias()
    @render()

  handleKeypress: (e) =>
    switch e.keyCode
      when 13 then @saveAndClose()  # Enter
      when 27 then @close()         # Esc

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

  setAlias: =>
    @chunk.set alias: @getAlias()

  setOptions: =>
    @chunk.set options: @options

  saveAndClose: (e) =>
    e.preventDefault() if e
    @setType()
    @setOptional()
    @setPassThrough()
    @setAlias()
    @setOptions()
    @close()

  deleteAndClose: =>
    @chunk.set anonymize: false

  close: =>
    @router.navigate("/edit", {trigger: true})  # NOTE: this is going to reset the sample

  getType: =>
    @$('input[name=type]:checked').val()

  getOptional: =>
    @$('input[name=optional]').is(":checked")

  getPassThrough: =>
    @$('input[name=pass_through]').is(":checked")

  getAlias: =>
    @$('input[name=alias]').val() or @chunk.get 'alias'
