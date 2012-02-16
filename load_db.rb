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

source = ARGV[0]

if File.exists?(source)
  puts "file found, purging existing Subjects"
  Subject.delete_all
  Filter.delete_all

  puts "starting load"
  lines = File.readlines(source)
  lines.each do |line|
    Subject.create! :text => line
  end

  puts "loaded, added #{Subject.count} subjects"
else
  pust "file not found"
end
