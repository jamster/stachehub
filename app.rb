require 'rubygems'
require 'eventmachine'
require 'sinatra/async'
require 'em-http-request'
require 'yajl/json_gem'
require 'pp'
require 'i18n'
require 'open-uri'
require 'nokogiri'

class Stachehub < Sinatra::Base
  register Sinatra::Async
  
  # For non heroku sites
  # LOGGER = logger = Logger.new('log/app.log')
  # 
  # def logger
  #   LOGGER
  # end
  
  set :logging, :true
  set :raise_errors, Proc.new { false }
  set :views, File.dirname(__FILE__) + '/templates'
  
  # get '/' do 
  #   'whoa'
  # end
  aget '/' do
    about_request = EM::HttpRequest.new("https://github.com/about").get
    about_request.callback do |http|
      webpage = Nokogiri::HTML(http.response)
      webpage.css('img[alt=Gravatar]').each do |gravatar|
        gravatar['src'] = "http://mustachify.me/magickly?mustachify=true&src=#{gravatar['src']}"
      end
      body webpage.to_html
    end
  end
end
