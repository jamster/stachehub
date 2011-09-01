require 'rubygems'
require 'eventmachine'
require 'sinatra/async'
require 'em-http-request'
require 'yajl/json_gem'
require 'pp'
require 'i18n'
require 'open-uri'


class Stachehub < Sinatra::Base
  register Sinatra::Async
  # LOGGER = logger = Logger.new('log/app.log')
  # 
  # def logger
  #   LOGGER
  # end
  
  set :logging, :true
  set :raise_errors, Proc.new { false }
  set :views, File.dirname(__FILE__) + '/templates'
  
  
  aget '/' do
    webpage = Nokogiri::HTML(html)
    webpage.css('img[alt=Gravatar]').each do |gravatar|
      gravatar['src'] = "http://mustachify.me/magickly?mustachify=true&src=#{gravatar['src']}"
    end
    webpage.to_html
  end
end
