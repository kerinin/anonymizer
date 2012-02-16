$: << File.dirname(__FILE__) + "/models"

require "rubygems"
require "sinatra"
require "haml"
require "json"
require "pp"
require "mongoid"
require "filter"

source_path = 'input.txt'
filters_path = 'filters.txt'
set :haml, :format => :html5
set :haml, :escape_html => true

Mongoid.load!("mongoid.yml")
Mongoid.logger = Logger.new($stdout)
#Mongoid.logger.level = 3

get '/' do
  File.read(File.join('public', 'index.html'))
end

get '/next' do
  lines = File.readlines(source_path)
  line = lines.sample
  chunks = line.split(' ').map {|text| {:content => text}}
  
  content_type :json
  chunks.to_json
end

post '/filters' do
  data = JSON.parse( request.body.read )
  Filter.create!(:search => search, :replace => replace)
end

get '/filters' do
  @filters = Filter.all
  haml :filters
end

post '/test_filter' do
  data = JSON.parse(request.body.read)
  filter = Filter.new(:search => data['search'], :replace => data['replace'])
  
  content_type :json
  filter.test_results.to_json
end
