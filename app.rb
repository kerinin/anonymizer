$: << File.dirname(__FILE__) + "/models"

require "rubygems"
require "sinatra"
require "haml"
require "json"
require "pp"
require "mongoid"
require "filter"
require "oauth"
require "gmail_xoauth"
require "active_support"

source_path = 'input.txt'
filters_path = 'filters.txt'
set :haml, :format => :html5
set :haml, :escape_html => true
enable :sessions

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


before do
  session[:oauth] ||= {}  
  
  consumer_key = ENV["CONSUMER_KEY"] || ENV["consumer_key"] || "anonymous"
  consumer_secret = ENV["CONSUMER_SECRET"] || ENV["consumer_secret"] || "anonymous"
  
  @consumer ||= OAuth::Consumer.new(consumer_key, consumer_secret,
    :site => "https://www.google.com",
    :request_token_path => '/accounts/OAuthGetRequestToken?scope=https://mail.google.com/%20https://www.googleapis.com/auth/userinfo%23email',
    :access_token_path => '/accounts/OAuthGetAccessToken',
    :authorize_path => '/accounts/OAuthAuthorizeToken'
  )
  
  if !session[:oauth][:request_token].nil? && !session[:oauth][:request_token_secret].nil?
    @request_token = OAuth::RequestToken.new(@consumer, session[:oauth][:request_token], session[:oauth][:request_token_secret])
  end
  
  if !session[:oauth][:access_token].nil? && !session[:oauth][:access_token_secret].nil?
    @access_token = OAuth::AccessToken.new(@consumer, session[:oauth][:access_token], session[:oauth][:access_token_secret])
  end
end

before /^(?!\/(request|auth))/ do
  redirect "/request" unless user_authorized?
end

get "/request" do
  @request_token = @consumer.get_request_token(:oauth_callback => "#{request.scheme}://#{request.host}:#{request.port}/auth")
  session[:oauth][:request_token] = @request_token.token
  session[:oauth][:request_token_secret] = @request_token.secret
  redirect @request_token.authorize_url
end

get "/auth" do
  @access_token = @request_token.get_access_token :oauth_verifier => params[:oauth_verifier]
  session[:oauth][:access_token] = @access_token.token
  session[:oauth][:access_token_secret] = @access_token.secret
  redirect "/"
end

get '/' do
  File.read(File.join('public', 'index.html'))
end

get '/next' do
  query = Subject.where(:matched.ne => true)
  line = query.skip( rand(query.count) ).first.text
  #chunks = line.split(' ').map {|text| {:content => text}}

  puts "#{query.count} in query, #{Subject.count} total"

  percent_matched = sprintf "%.1f%", 100 * ((Subject.count - query.count) / Subject.count.to_f)
  chunks = {:content => line}
  
  content_type :json
  {:chunks => chunks, :percent_matched => percent_matched, :filter_count => Filter.count}.to_json
end

post '/filters' do
  data = JSON.parse( request.body.read )
  filter = Filter.create!(:search => data['search'], :replace => data['replace'])

  puts "#{Subject.where(:text => filter.regex).count} matches"
  puts "#{Subject.where(:matched.ne => true).count} unmatched to start"

  # mark any subject lines this matches
  Subject.where(:text => filter.regex).update_all(:matched => true)
  puts "#{Subject.where(:matched.ne => true).count} unmatched now"
end

get '/filters' do
  @filters = Filter.order_by([:replace => :asc])
  haml :filters
end

post '/test_filter' do
  data = JSON.parse(request.body.read)
  filter = Filter.new(:search => data['search'], :replace => data['replace'])
  
  content_type :json
  filter.test_results.to_json
end

private

def user_authorized?
  return false unless @access_token

  response = @access_token.get('https://www.googleapis.com/userinfo/email?alt=json')
  if response.is_a?(Net::HTTPSuccess)
    @email = JSON.parse(response.body)['data']['email']
  end

  @email.end_with? "@otherinbox.com"
end
