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

Mongoid.configure do |config|
  if ENV['MONGOHQ_URL']
    conn = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'])
    uri = URI.parse(ENV['MONGOHQ_URL'])
    config.master = conn.db(uri.path.gsub(/^\//, ''))
  else
    config.master = Mongo::Connection.from_uri("mongodb://localhost:27017").db('anonymizer')
  end
  config.autocreate_indexes = true
end
Mongoid.logger = Logger.new($stdout)
#Mongoid.logger.level = 3

get '/' do
  File.read(File.join('public', 'index.html'))
end

get '/next' do
  query = Subject.where(:matched.ne => true)
  line = query.skip( rand(query.count) ).first.text
  chunks = line.split(' ').map {|text| {:content => text}}
  
  content_type :json
  chunks.to_json
end

post '/filters' do
  data = JSON.parse( request.body.read )
  filter = Filter.create!(:search => data['search'], :replace => data['replace'])

  puts "#{Subject.where(:text => filter.regex).count} matches"
  puts "#{Subject.where(:matched.ne => true).count} unmatched to start"
  # mark any subject lines this matches
  Subject.where(:text => filter.regex).update_all(:matched => true)
  puts "#{Subject.where(:matched.ne => true).count} unmatched to now"
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
