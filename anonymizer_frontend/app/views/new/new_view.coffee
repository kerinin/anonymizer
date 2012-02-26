class exports.NewView extends Backbone.View
  id: 'new-view'

  initialize: =>
    @model = @sample = @options['sample']
    @router = @options['router']
    
    @bind() if @options['bind'] isnt false

  bind: =>
    @sample.get('chunks').bind 'reset', @navigateToEdit

  unbind: =>
    @sample.get('chunks').unbind 'reset', @navigateToEdit
    
  remove: =>
    @unbind()

  render: =>
    @$(@el).html require('./templates/new')
    this

  navigateToEdit: =>
    @router.navigate('/edit', {trigger: true})
