class exports.NewView extends Backbone.View
  id: 'new-view'

  initialize: =>
    @model = @redactor = @options['redactor']
    @router = @options['router']
    
    @bind() if @options['bind'] isnt false

  bind: =>
    @redactor.get('chunks').bind 'reset', @navigateToEdit

  unbind: =>
    @redactor.get('chunks').unbind 'reset', @navigateToEdit
    
  remove: =>
    @unbind()
    @$(@el).remove()

  render: =>
    @$(@el).html require('./templates/new')
    this

  navigateToEdit: =>
    @router.navigate('/edit', {trigger: true})
