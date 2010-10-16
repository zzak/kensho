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
  
  get '/' do
    haml :index
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
      @errors = @validator.validate_text(params[:markup]).errors
      @warnings = @validator.validate_text(params[:markup]).warnings 
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
