matchesTemplate = require('./templates/_matches')

class exports.MatchesView extends Backbone.View
  id: 'ajax'

  events:
    'click .get_matches': 'getMatches'

  initialize: =>
    @router = @options['router']
    @model = @chunk = @options['chunk']
    @state = 'idle'

    @bind() if @options['bind'] isnt false

  bind: =>
    @chunk.bind 'change:type', @getMatches

  unbind: =>
    @chunk.unbind 'change:type', @getMatches

  remove: =>
    @unbind()
    @$(@el).remove()

  render: =>
    @$(@el).html matchesTemplate(chunk: @chunk, state: @state)
    this

  getMatches: =>
    @chunk.getMatches @handleMatchesSuccess, @handleMatchesFailure
    @state = 'waiting'
    @render()

  handleMatchesSuccess: (results) =>
    if results['regex'] == @chunk.collection.searchText()
      @chunk.set matches: results['results']
      @state = 'received'
      @render()

  handleMatchesFailure: (results) =>
    @state = 'error'
    @render()
