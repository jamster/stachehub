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
  set :public, Proc.new { File.join(File.dirname(__FILE__), "public") }
  
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
      webpage.css("body").children.first.add_previous_sibling(<<-FORK)
      <a href="http://github.com/jamster/stachehub"><img style="position: absolute; top: 0; right: 0; border: 0;" src="https://a248.e.akamai.net/assets.github.com/img/7afbc8b248c68eb468279e8c17986ad46549fb71/687474703a2f2f73332e616d617a6f6e6177732e636f6d2f6769746875622f726962626f6e732f666f726b6d655f72696768745f6461726b626c75655f3132313632312e706e67" alt="Fork me on GitHub"></a>
      FORK
      webpage.css('img[alt=Gravatar]').each do |gravatar|
        # puts gravatar.parent['href']
        x = gravatar.parent['href'].gsub(/\//, '')
        puts gravatar.parent['href']
        puts x.to_s
        puts gravatar
        image = case x.to_s
        when 'rtomayko'
          '/images/ryan_tomayako.png'
        when 'atmos'
          '/images/corey_donahue_stache.png'
        when 'probablycorey'
          '/images/dog_stache.png'
        when 'joshaber'
          '/images/abstract_stache.png'
        when 'jsncostello'
          'images/jc_stache.png'
        when 'benburkert'
          'images/bellybutton.png'
        when 'bleikamp'
          'images/bleikamp.png'
        when 'mtodd'
          'images/mtodd.png'
        when 'tclem'
          'images/tim_clem.png'
        when 'tanoku'
          'images/cat_stache.png'
        else
          "http://mustachify.me/magickly?mustachify=true&src=#{gravatar['src']}"
        end
        gravatar['src'] = image
      end
      octocat = webpage.css('img[alt=Octocat]')
      octocat.last['src'] = '/images/octostache.png'

      octonaut = webpage.css('img[alt=Octonaut]')
      octonaut.last['src'] = '/images/parallax_octocat_stache.png'

      webpage.children.last.add_next_sibling(<<-GA)
      <script type="text/javascript">

        var _gaq = _gaq || [];
        _gaq.push(['_setAccount', 'UA-25484519-1']);
        _gaq.push(['_trackPageview']);

        (function() {
          var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
          ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
          var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
        })();

      </script>
      GA
      body webpage.to_html
    end
  end
end
