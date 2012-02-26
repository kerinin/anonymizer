{Redactor} = require 'models/redactor'


class exports.RedactorCollection extends Backbone.Collection
  model: Redactor

  url: '/redactors'
