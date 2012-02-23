class exports.NewView extends Backbone.View
  id: 'new-view'

  initialize: =>
    @router = @options['router']
    
    @bind() if @options['bind'] isnt false

  bind: =>
    @collection.bind 'reset', @navigateToEdit

  unbind: =>
    @collection.unbind 'reset'
    
  remove: =>
    @unbind()

  render: =>
    @$(@el).html require('./templates/new')
    this

  navigateToEdit: =>
    @router.navigate('/edit', {trigger: true})
