class exports.Chunk extends Backbone.Model
  defaults:
    content: ''
    anonymize: false
    alias: 'redacted'
    collapse: false
    # @param type For anonymized chunks, 'type' describes how the chunk should be treated
    #   in the resulting regex.  The default option ('glob') uses a generalized matcher
    #   (.*) and relies on the surrounding chunks to provide context.  Other options are
    #   'set', which matches any strings in the `options` array, 'char-set', which has
    #   the same behavior but expects single characters, 'literal', which matches the escaped
    #   contents of the `content` attribute, 'numeric' which matches an arbitrary number of
    #   numeric characters, and 'glob-excl', which behaves similar to 'glob' but mathes any 
    #   characters NOT in the `options` array (also expects single characters in `options`)
    type: 'glob'        
    # @param options For set-based types, describes the (unescaped) options to match on
    options: []         
    # for optional redactions (matches even if the chunk isn't present)
    optional: false     
    # @param pass_through Re-inserts captured content for anonymized chunks which capture content
    #   if set to true.  When false (for anonymized chunks) inserts the contents of `alias`
    #   in brackets.
    pass_through: false

    matches: []

  initialize: =>
    memento = new Backbone.Memento(this)
    _.extend(this, memento)

  typeIs: (value) =>
    @get('type') is value

  toggleAnonymize: =>
    @set anonymize: not @get 'anonymize'

  searchText: ->
    if @get('anonymize') and @get('collapse') isnt true
      matcher = switch @get 'type'
        # -> ((?:foo)|(?:bar))
        when 'set' then "(#{("(?:#{XRegExp.escape match})" for match in @get("options")).join('|')})"
        # -> (A|b|\$)
        when 'char-set' then "(#{(XRegExp.escape match for match in @get("options")).join('|')})"
        # -> (?:foo)
        when 'literal' then "(?:#{XRegExp.escape @get('content')})"
        # -> (\d*)
        when 'numeric' then '([\\.|\\d]*)'
        # -> ([^A|b|\$]*)
        when 'glob-excl' then "([^#{(XRegExp.escape match for match in @get("options")).join('|')}]*)"
        when 'char' then '(.)'
        else '(.*)'
      if @get("optional") then "#{matcher}?" else matcher
    else if not @get 'anonymize'
      XRegExp.escape @get 'content'
        
  replaceText: ->
    if @get('anonymize') and @get('collapse') isnt true
      if @get("pass_through") then "\\#{@anonymizedIndex()+1}" else "<#{@get "alias"}>"
    else if not @get 'anonymize'
      @get 'content'

  index: =>
    @collection.models.indexOf this

  anonymizedIndex: =>
    (i for i in @collection.models when i.get("anonymize")).indexOf this

  replaceWith: (chunks) =>
    @collection.add chunks.reverse(), {at: @index(), silent: true}
    @collection.remove this
 
  getMatches: (callback, failback) =>
    @post
      search: @collection.searchText(),
    , "/get_matches/#{@anonymizedIndex()+1}", callback, failback

  post: (data, url, callback, failback) =>
    $.ajax
      type: "POST",
      url: url,
      data: JSON.stringify(data),
      contentType: "application/json; charset=utf-8",
      dataType: "json",
      success: callback,
      failure: failback

