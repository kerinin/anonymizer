{CreateView} = require 'views/create/create_view'

class exports.ChunkEditView extends Backbone.View
  id: 'chunk_edit_view'

  events:
    'click': 'noOp'

  render: ->
    @$(@el).html require('./templates/chunk_edit')
    this

  noOp: ->

