require "rubygems"
require "bundler"
Bundler.setup

require "sinatra/base"
require "sass"
require "haml"
require "w3c_validators"

class Kensho < Sinatra::Base
  
  set :public, File.dirname(__FILE__) + '/public'

  get '/' do
    haml :index
  end

  get '/validate' do
    haml :validate
  end

  get '/stylesheet.css' do
    content_type 'text/css', :charset => 'utf-8'
    sass :stylesheet
  end

end
