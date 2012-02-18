class exports.NewView extends Backbone.View
  id: 'new-view'

  initialize: =>
    @router = @options['router']
    
    @collection.bind 'reset', @navigateToEdit

  render: =>
    @$(@el).html require('./templates/new')
    this

  navigateToEdit: =>
    @router.navigate('/edit', {trigger: true})
