$: << File.dirname(__FILE__) + "/models"

require "rubygems"
require "mongoid"
require "subject"
require "filter"

ENV['RACK_ENV'] = 'development'
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
Mongoid.logger.level = 3

destination_path = ARGV[0]

destination = File.open(destination_path, 'w')

Filter.order_by([:search => :asc]).all.each do |filter|
  # RM NOTE: this should be removed - fixing an oversight in file parsing...
  puts "#{filter.search.gsub(/\n/,'')}"
  puts "#{filter.replace}"
  puts "----------------"
  destination << "#{filter.search.gsub(/\n/,'')}\t#{filter.replace}\n"
end
