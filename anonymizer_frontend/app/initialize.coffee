{BrunchApplication} = require 'helpers'
{MainRouter} = require 'routers/main_router'

{HomeView} = require 'views/create/home_view'
{StringView} = require 'views/create/string_view'
{SearchView} = require 'views/create/search_view'
{ReplaceView} = require 'views/create/replace_view'
{TestView} = require 'views/create/test_view'

{Sample} = require 'collections/sample'
{TestResults} = require 'collections/test_results'

class exports.Application extends BrunchApplication
  # This callback would be executed on document ready event.
  # If you have a big application, perhaps it's a good idea to
  # group things by their type e.g. `@views = {}; @views.home = new HomeView`.
  initialize: ->
    @router = new MainRouter
    @homeView = new HomeView
    @sample = new Sample
    @test_results = new TestResults
    @views = {}
    @views.stringView = new StringView model: @sample
    @views.searchView = new SearchView model: @sample
    @views.replaceView = new ReplaceView collection: @sample
    @views.testView = new TestView collection: @test_results

window.app = new exports.Application
