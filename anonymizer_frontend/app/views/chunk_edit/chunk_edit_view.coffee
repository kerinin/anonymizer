chunkEditTemplate = require('./templates/chunk_edit')

class exports.ChunkEditView extends Backbone.View
  id: 'chunk_edit_view'
  tagName: 'form'

  events:
    'click': 'noOp'
    'click .save': 'saveAndClose'
    'click .cancel': 'close'
    'submit': 'saveAndClose'

  initialize: =>
    @router = @options['router']
    @chunk = @options['chunk']

  render: =>
    @$(@el).html chunkEditTemplate()
    @$("input:radio[name=type][value=#{@chunk.get("type")}]").attr("checked", true)
    @$("input[name=optional]").attr("checked", @chunk.get("optional"))
    @$("input[name=pass_through]").attr("checked", @chunk.get("pass_through"))
    this

  setType: =>
    @chunk.set type: @$('input[name=type]:checked').val()

  setOptional: =>
    @chunk.set optional: @$('input[name=optional]').is(":checked")

  setPassThrough: =>
    @chunk.set pass_through: @$('input[name=pass_through]').is(":checked")

  saveAndClose: =>
    @setType()
    @setOptional()
    @setPassThrough()
    @close()

  close: =>
    @router.navigate("/edit", {trigger: true})  # NOTE: this is going to reset the sample

  noOp: =>

