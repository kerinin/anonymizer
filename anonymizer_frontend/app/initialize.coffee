{BrunchApplication} = require 'helpers'
{MainRouter} = require 'routers/main_router'

{Sample} = require 'collections/sample'
{TestResults} = require 'collections/test_results'

class exports.Application extends BrunchApplication
  # This callback would be executed on document ready event.
  # If you have a big application, perhaps it's a good idea to
  # group things by their type e.g. `@views = {}; @views.home = new HomeView`.
  initialize: ->
    @router = new MainRouter
    @sample = new Sample
    @test_results = new TestResults @sample

window.app = new exports.Application
