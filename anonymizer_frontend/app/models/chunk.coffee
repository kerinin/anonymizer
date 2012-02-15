class exports.Chunk extends Backbone.Model
  defaults:
    content: ''
    anonymize: false

  toggle: =>
    @set anonymize: not @get 'anonymize'
