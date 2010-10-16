require "rubygems"
require "bundler"
Bundler.setup

require "sinatra/base"
require "sass"
require "haml"
require "w3c_validators"

class Kensho < Sinatra::Base

  include W3CValidators

  set :public, File.dirname(__FILE__) + '/public'
  
  get '/' do
    haml :index
  end

  post '/validate' do
    case params[:type]
      when "HTML"
        @validator = MarkupValidator.new
        @validator.set_debug!(true)
      when "FEED"
        @validator = FeedValidator.new(:validator_uri => "http://validator.w3.org/feed/check.cgi")
      when "CSS"
        @validator = CSSValidator.new
        @validator.set_warn_level!(2) 
      else
        @validator = nil
    end
   
    begin
      @errors = @validator.validate_text(params[:markup]) 
    rescue W3CValidators::ValidatorUnavailable
      @errors = nil
      @exception = "Unable to connect to validator, perhaps your request was too large" 
    rescue Net::HTTPRetriableError
      @errors = nil
      @exception = "Unable to connect to validator, response 302"
    end

    haml :validate
  end

  get '/stylesheet.css' do
    content_type 'text/css', :charset => 'utf-8'
    sass :stylesheet
  end

end
