class exports.Chunk extends Backbone.Model
  defaults:
    content: ''
    anonymize: false
    alias: 'redacted'
    collapse: false

  toggleAnonymize: =>
    @set anonymize: not @get 'anonymize'

  searchText: ->
    if @get('anonymize') and @get('collapse') isnt true
      '(.*)'
    else if not @get 'anonymize'
      XRegExp.escape @get 'content'
        
  replaceText: =>
    if @get('anonymize') and @get('collapse') isnt true
      ( if @get('alias') then "<#{@get('alias')}>" else "<redacted>" )
    else if not @get 'anonymize'
      @get 'content'

  index: =>
    @collection.models.indexOf this

  replaceWith: (chunks) ->
    @collection.add chunks.reverse(), {at: @index(), silent: true}
    @collection.remove this
 
