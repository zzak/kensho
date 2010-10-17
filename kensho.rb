require "rubygems"
require "bundler"
Bundler.setup

require "sinatra/base"
require "sass"
require "haml"
require "w3c_validators"
require "nokogiri"

class Kensho < Sinatra::Base

  include W3CValidators

  set :public, File.dirname(__FILE__) + '/public'
 
  get '/help' do
    haml :help, :layout => false
  end

  get '/' do
    haml :index
  end

  post '/api/:api/:type' do
   
    @markup = params[:markup][:tempfile].read
    case params[:type]
      when "html"
        @validator = MarkupValidator.new
        @validator.set_debug!(true)
      when "css"
        @validator = CSSValidator.new
        @validator.set_warn_level!(2)
      when "feed"
        @validator = Nokogiri::XML.parse(@markup) 
      else
        @validator = nil 
    end
  
    if params[:type] == "html" || params[:type] == "css"
      begin 
        @errors = @validator.validate_text(@markup).errors
        @warnings = @validator.validate_text(@markup).warnings 
      rescue W3CValidators::ValidatorUnavailable
        @errors = nil
        @warnings = nil
        @exception = "Unable to connect to validator, perhaps your request was too large"
      rescue Net::HTTPRetriableError
        @errors = nil
        @warnings = nil
        @exception = "Unable to connect to validator, response unavailable"
      rescue
        @errors = nil
        @warnings = nil
        @exception = "Unable to validate markup"
      end
    elsif params[:type] == "feed"
      @errors = @validator.errors
      @warnings = nil 
    else
      @errors = nil
      @warnings = nil 
    end
  
    @results = Hash.new
    @results[:errors] = @errors unless @errors.nil?
    @results[:warnings] = @warnings unless @warnings.nil? 

    if params[:api] == 'yaml'
      require 'yaml'
      return @results.to_yaml
      return @exception unless @exception.nil? 
    elsif params[:api] == 'json'
      return @results.to_json
      return @exception unless @exception.nil? 
    else
      return nil
      return @exception unless @exception.nil? 
    end
  end

  post '/validate' do
    case params[:type]
      when "HTML"
        @validator = MarkupValidator.new
        @validator.set_debug!(true)
      when "FEED"
        @validator = Nokogiri::XML.parse(params[:markup])
      when "CSS"
        @validator = CSSValidator.new
        @validator.set_warn_level!(2) 
      else
        @validator = nil
    end
   
    if params[:type] == "HTML" || params[:type] == "CSS"
       begin 
        @errors = @validator.validate_text(params[:markup]).errors
        @warnings = @validator.validate_text(params[:markup]).warnings 
      rescue W3CValidators::ValidatorUnavailable
        @errors = nil
        @warnings = nil
        @exception = "Unable to connect to validator, perhaps your request was too large"
      rescue Net::HTTPRetriableError
        @errors = nil
        @warnings = nil
        @exception = "Unable to connect to validator, response unavailable"
      rescue
        @errors = nil
        @warnings = nil
        @exception = "Unable to validate markup"
      end
   elsif params[:type] == "FEED"
      @errors = @validator.errors
    else
      @errors = nil
    end

    haml :validate
  end

  get '/stylesheet.css' do
    content_type 'text/css', :charset => 'utf-8'
    sass :stylesheet
  end

end
