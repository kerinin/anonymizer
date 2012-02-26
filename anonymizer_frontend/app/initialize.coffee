{BrunchApplication} = require 'helpers'
{MainRouter} = require 'routers/main_router'

{RedactionScope} = require 'models/redaction_scope'
{Redactor} = require 'models/redactor'
{TestResults} = require 'collections/test_results'

class exports.Application extends BrunchApplication
  # This callback would be executed on document ready event.
  # If you have a big application, perhaps it's a good idea to
  # group things by their type e.g. `@views = {}; @views.home = new HomeView`.
  initialize: ->
    @router = new MainRouter
    @scope = new RedactionScope
    @redactor = new Redactor
    @scope.get('redactors').add(@redactor)
    @test_results = new TestResults @redactor
    @current_views = []

window.app = new exports.Application
