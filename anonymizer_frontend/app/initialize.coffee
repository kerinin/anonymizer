{BrunchApplication} = require 'helpers'
{MainRouter} = require 'routers/main_router'
{HomeView} = require 'views/home_view'
{StringView} = require 'views/string_view'
{SearchView} = require 'views/search_view'
{ReplaceView} = require 'views/replace_view'
{Sample} = require 'collections/sample'

class exports.Application extends BrunchApplication
  # This callback would be executed on document ready event.
  # If you have a big application, perhaps it's a good idea to
  # group things by their type e.g. `@views = {}; @views.home = new HomeView`.
  initialize: ->
    @router = new MainRouter
    @homeView = new HomeView
    @sample = new Sample
    @views = {}
    @views.stringView = new StringView model: @sample
    @views.searchView = new SearchView model: @sample
    @views.replaceView = new ReplaceView model: @sample

window.app = new exports.Application
