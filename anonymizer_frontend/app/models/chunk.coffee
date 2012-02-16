class exports.Chunk extends Backbone.Model
  defaults:
    content: ''
    anonymize: false
    alias: 'redacted'
    collapse: false

  toggleAnonymize: =>
    @set anonymize: not @get 'anonymize'
    @collection.groupChunks()

  searchText: ->
    if @get('anonymize') and @get('collapse') isnt true
      '(.*)'
    else if not @get 'anonymize'
      XRegExp.escape @get 'content'
      @get 'content'
        
  replaceText: =>
    if @get('anonymize') and @get('collapse') isnt true
      ( if @get('alias') then "<#{@get('alias')}>" else "<redacted>" )
    else if not @get 'anonymize'
      @get 'content'

