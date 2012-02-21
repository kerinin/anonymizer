$: << File.dirname(__FILE__) + "/models"
require "rubygems"
require "mongoid"
require "subject"
require "filter"
require "faker"

ENV['RACK_ENV'] = 'development'
Mongoid.configure do |config|
  if ENV['MONGOHQ_URL']
    conn = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'])
    uri = URI.parse(ENV['MONGOHQ_URL'])
    config.master = conn.db(uri.path.gsub!(/^\//, ''))
  else
    config.master = Mongo::Connection.from_uri("mongodb://localhost:27017").db('anonymizer')
  end
  config.autocreate_indexes = true
end
Mongoid.logger = Logger.new($stdout)
Mongoid.logger.level = 3

count = ARGV[0] || 200

filters = {
  /^"(.*)":\ (.*)\ $/ =>   "\"<group_name>\": <thread_title> ",
  /^([\.|\d]*)\ amigos\ aguardando\ sua\ resposta\ $/ =>   "<n> amigos aguardando sua resposta ",
  /^(.*)\ added\ a\ friend\ that\ you\ suggested\.\.\.\ $/  =>   "<user_name> added a friend that you suggested... ",
  /^(.*)\ added\ a\ new\ photo\ to\ the\ album\ (.*)\ $/  =>   "<user_name> added a new photo to the album <album> ",
  /^(.*)\ added\ new\ photos\ to\ the\ album\ (.*)\ $/  =>   "<user_name> added new photos to the album <album> ",
  /^(.*)\ also\ commented\ on\ (.*)'s\ link\.\ $/ =>   "<user_name> also commented on <another_user>'s link. ",
  /^(.*)\ also\ commented\ on\ (.*)'s\ photo\ album\.\ $/ =>   "<user_name> also commented on <another_user>'s photo album. ",
  /^(.*)\ also\ commented\ on\ (.*)'s\ photo\.\ $/  =>   "<user_name> also commented on <another_user>'s photo. ",
  /^(.*)\ also\ commented\ on\ (.*)'s\ post\.\ $/ =>   "<user_name> also commented on <another_user>'s post. ",
  /^(.*)\ also\ commented\ on\ (.*)'s\ status\.\ $/ =>   "<user_name> also commented on <another_user>'s status. ",
  /^(.*)\ also\ commented\ on\ her\ note\ "(.*)"\ $/  =>   "<user_name> also commented on her note \"<title>\" ",
  /^(.*)\ also\ commented\ on\ her\ photo\.\ $/ =>   "<user_name> also commented on her photo. ",
  /^(.*)\ also\ commented\ on\ her\ status\.\ $/  =>   "<user_name> also commented on her status. ",
  /^(.*)\ also\ commented\ on\ his\ status\ update\.\ $/  =>   "<user_name> also commented on his status update. ",
  /^(.*)\ also\ commented\ on\ his\ status\.\ $/  =>   "<user_name> also commented on his status. ",
  /^(.*)\ asked\ to\ join\ (.*)\ $/ =>   "<user_name> asked to join <group_name> ",
  /^(.*)\ commented\ on\ (.*)'s\ Wall\ post\.\ $/ =>   "<user_name> commented on <another_user>'s Wall post. ",
  /^(.*)\ commented\ on\ (.*)'s\ check\-in\ at\ (.*)\.\ $/  =>   "<user_name> commented on <another_user>'s check-in at <location>. ",
  /^(.*)\ commented\ on\ (.*)'s\ photo\ of\ you\.\ $/ =>   "<user_name> commented on <another_user>'s photo of you. ",
  /^(.*)\ commented\ on\ a\ post\ you\ were\ tagged\ in\.\ $/ =>   "<user_name> commented on a post you were tagged in. ",
  /^(.*)\ commented\ on\ his\ Wall\ post\.\ $/  =>   "<user_name> commented on his Wall post. ",
  /^(.*)\ commented\ on\ his\ photo\ of\ you\.\ $/  =>   "<user_name> commented on his photo of you. ",
  /^(.*)\ commented\ on\ his\ post\.\ $/  =>   "<user_name> commented on his post. ",
  /^(.*)\ commented\ on\ your\ activity\.\ $/ =>   "<user_name> commented on your activity. ",
  /^(.*)\ commented\ on\ your\ changed\ relationship\ status\.\ $/  =>   "<user_name> commented on your changed relationship status. ",
  /^(.*)\ commented\ on\ your\ link\.\ $/ =>   "<user_name> commented on your link. ",
  /^(.*)\ commented\ on\ your\ photo\.\ $/  =>   "<user_name> commented on your photo. ",
  /^(.*)\ commented\ on\ your\ post\.\ $/ =>   "<user_name> commented on your post. ",
  /^(.*)\ commented\ on\ your\ status\.\ $/ =>   "<user_name> commented on your status. ",
  /^(.*)\ confirmed\ you\ as\ a\ friend\ on\ Facebook\ $/ =>   "<user_name> confirmed you as a friend on Facebook ",
  /^(.*)\ confirmed\ you\ as\ a\ friend\ on\ Facebook\.\ $/ =>   "<user_name> confirmed you as a friend on Facebook. ",
  /^(.*)\ invited\ you\ to\ the\ event\ (.*)\ $/  =>   "<user_name> invited you to the event <event> ",
  /^(.*)\ is\ at\ (.*)\ with\ (.*)\ $/  =>   "<user_name> is at <location> with <another_user> ",
  /^(.*)\ is\ at\ (.*):\ "(.*)"\ $/ =>   "<user_name> is at <location>: \"<comment>\" ",
  /^(.*)\ likes\ a\ check\-in\ you\ are\ tagged\ in\ $/ =>   "<user_name> likes a check-in you are tagged in ",
  /^(.*)\ likes\ a\ photo\ you\ are\ tagged\ in\ $/ =>   "<user_name> likes a photo you are tagged in ",
  /^(.*)\ likes\ a\ status\ you\ are\ tagged\ in\ $/  =>   "<user_name> likes a status you are tagged in ",
  /^(.*)\ likes\ your\ activity\.\ $/ =>   "<user_name> likes your activity. ",
  /^(.*)\ likes\ your\ comment\.\ $/  =>   "<user_name> likes your comment. ",
  /^(.*)\ likes\ your\ link\.\ $/ =>   "<user_name> likes your link. ",
  /^(.*)\ likes\ your\ photo\.\ $/  =>   "<user_name> likes your photo. ",
  /^(.*)\ likes\ your\ status\.\ $/ =>   "<user_name> likes your status. ",
  /^(.*)\ mentioned\ you\ on\ Facebook\ $/  =>   "<user_name> mentioned you on Facebook ",
  /^(.*)\ posted\ a\ note:\ (.*)\ $/  =>   "<user_name> posted a note: <note> ",
  /^(.*)\ posted\ on\ your\ Wall\ $/  =>   "<user_name> posted on your Wall ",
  /^(.*)\ shared\ (.*)'s\ photo\ $/ =>   "<user_name> shared <another_user>'s photo ",
  /^(.*)\ shared\ (.*)'s\ status\ update\ $/  =>   "<user_name> shared <another_user>'s status update ",
  /^(.*)\ shared\ a\ foto\ $/ =>   "<user_name> shared a foto ",
  /^(.*)\ shared\ a\ link\ $/ =>   "<user_name> shared a link ",
  /^(.*)\ shared\ a\ link\ on\ your\ Wall\.\ $/ =>   "<user_name> shared a link on your Wall. ",
  /^(.*)\ shared\ a\ page\ $/ =>   "<user_name> shared a page ",
  /^(.*)\ suggested\ you\ like\ (.*)\ $/  =>   "<user_name> suggested you like <topic> ",
  /^(.*)\ tagged\ a\ photo\ of\ you\ on\ Facebook\ $/ =>   "<user_name> tagged a photo of you on Facebook ",
  /^(.*)\ tagged\ you\ at\ (.*)\.\.\.\ $/ =>   "<user_name> tagged you at <location>... ",
  /^(.*)\ tagged\ you\ in\ a\ photo\ near\ (.*)\ $/ =>   "<user_name> tagged you in a photo near <location> ",
  /^(.*)\ tagged\ you\ in\ a\ post\ $/  =>   "<user_name> tagged you in a post ",
  /^(.*)\ tagged\ you\ on\ Facebook\ $/ =>   "<user_name> tagged you on Facebook ",
  /^(.*)\ updated\ her\ status:\ "(.*)\ $/  =>   "<user_name> updated her status: \"<status> ",
  /^(.*)\ updated\ his\ status:\ "(.*)\ $/  =>   "<user_name> updated his status: \"<status> ",
  /^(.*)\ wants\ to\ be\ friends\ on\ Facebook\ $/  =>   "<user_name> wants to be friends on Facebook ",
  /^(.*)\ wrote\ on\ the\ Wall\ for\ (.*)\.\ $/ =>   "<user_name> wrote on the Wall for <another_user>. ",
  /^(.*)\,\ you\ have\ notifications\ pending\ $/ =>   "<user_name>, you have notifications pending ",
  /^Facebook\ Account\ Linked\ With\ Google\ $/ =>   "Facebook Account Linked With Google ",
  /^Facebook\ login\ using\ Spotify\ $/ =>   "Facebook login using Spotify ",
  /^Facebook\ login\ using\ an\ unknown\ device\ from\ (.*)\ \(IP=([\.|\d]*)\)\ $/  =>   "Facebook login using an unknown device from <location> (IP=<ip>) ",
  /^How\ to\ Get\ the\ Most\ Out\ of\ Facebook\ $/  =>   "How to Get the Most Out of Facebook ",
  /^New\ message\ from\ (.*)\ $/  =>   "New message from <user_name> ",
  /^New\ messages\ from\ (.*)\ $/ =>   "New messages from <user_name> ",
  /^New\ messages\ from\ (.*)\ and\ (.*)\ $/  =>   "New messages from <user_name> and <another_user> ",
  /^Re:\ \[(.*)\]\ (.*)\ $/ =>   "Re: [<group_name>] <thread_title> ",
  /^Reminder:\ (.*)\ invited\ you\ to\ join\ Facebook\.\.\.\ $/ =>   "Reminder: <user_name> invited you to join Facebook... ",
  /^You\ have\ ([\.|\d]*)\ friends\ with\ birthdays\ this\ week\ $/ =>   "You have <n> friends with birthdays this week ",
  /^You\ have\ ([\.|\d]*)\ friends\ with\ upcoming\ birthdays\ $/ =>   "You have <n> friends with upcoming birthdays ",
  /^Your\ Weekly\ Facebook\ Page\ Update\ $/  =>   "Your Weekly Facebook Page Update ",
  /^\[(.*)\]\ (.*)\ $/  =>   "[<group_name>] <thread_title> "
}

puts "emptying database"
Subject.delete_all
Filter.delete_all

filters.each_value do |value|
  puts "starting #{value}"

  (rand(count.to_i) + 1).times do
    new_value = value
    new_value.gsub! '<user_name>', Faker::Name.name
    new_value.gsub! '<another_user>', Faker::Name.name
    new_value.gsub! '<n>', rand(100).to_s
    new_value.gsub! '<group_name>', Faker::Company.bs
    new_value.gsub! '<thread_title>', Faker::Lorem.sentence
    new_value.gsub! '<status>', Faker::Lorem.sentence(6)
    new_value.gsub! '<location>', Faker::Address.city
    new_value.gsub! '<topic>', Faker::Lorem.sentence(6)
    new_value.gsub! '<note>', Faker::Lorem.sentence
    new_value.gsub! '<album>', Faker::Company.bs
    new_value.gsub! '<title>', Faker::Lorem.sentence
    new_value.gsub! '<event>', Faker::Company.catch_phrase
    new_value.gsub! '<comment>', Faker::Lorem.sentence
    new_value.gsub! '<ip>', Faker::Internet.ip_v4_address
    Subject.create! :text => new_value
  end
end

puts "created #{Subject.count} subjects"
