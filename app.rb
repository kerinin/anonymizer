require "rubygems"
require "sinatra"
require "json"

source = 'input.txt'

get '/' do
  File.read(File.join('public', 'index.html'))
end

get '/next' do
  lines = File.readlines(source)
  line = lines.sample
  chunks = line.split(' ').map {|text| {:content => text}}
  
  content_type :json
  chunks.to_json
end
