$: << File.dirname(__FILE__) + "/models"

require "rubygems"
require "mongoid"
require "subject"

ENV['RACK_ENV'] = 'development'
Mongoid.load!("mongoid.yml")
Mongoid.logger = Logger.new($stdout)
Mongoid.logger.level = 3

source = ARGV[0]

if File.exists?(source)
  puts "file found, purging existing Subjects"
  Subject.delete_all

  puts "starting load"
  lines = File.readlines(source)
  lines.each do |line|
    Subject.create!(:text => line)
  end

  puts "loaded, added #{Subject.count} subjects"
else
  pust "file not found"
end
