chunkEditTemplate = require('./templates/chunk_edit')

class exports.ChunkEditView extends Backbone.View
  id: 'chunk_edit_view'

  events:
    'click': 'noOp'
    'click .save': 'saveAndClose'
    'click .cancel': 'close'

  initialize: =>
    @router = @options['router']
    @chunk = @options['chunk']

  render: =>
    @$(@el).html chunkEditTemplate()
    @$("input:radio[name=type][value=#{@chunk.get("type")}]").attr("checked", true)
    this

  setType: =>
    @chunk.set type: @$('input[name=type]:checked').val()

  setOptional: =>
    @chunk.set optional: @$('input[name=optional]').val()

  setPassThrough: =>
    @chunk.set pass_through: @$('input[name=pass_through]').val()

  saveAndClose: =>
    @setType()
    @setOptional()
    @setPassThrough()
    @close()

  close: =>
    @router.navigate("/edit", {trigger: true})  # NOTE: this is going to reset the sample

  noOp: =>

