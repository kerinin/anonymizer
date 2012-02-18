class exports.ChunkEditView extends Backbone.View
  id: 'chunk_edit_view'

  events:
    'click': 'noOp'
    'click .save': 'saveAndClose'
    'click .cancel': 'close'

  render: =>
    @$(@el).html require('./templates/chunk_edit')
    @$("input:radio[name=type][value=#{@model.get("type")}]").attr("checked", true)
    this

  setType: =>
    @model.set type: @$('input[name=type]:checked').val()

  setOptional: =>
    @model.set optional: @$('input[name=optional]').val()

  setPassThrough: =>
    @model.set pass_through: @$('input[name=pass_through]').val()

  saveAndClose: ->
    @setType()
    @setOptional()
    @setPassThrough()
    @close()

  close: ->
    app.router.navigate("/edit", {trigger: true})  # NOTE: this is going to reset the sample

  noOp: ->

