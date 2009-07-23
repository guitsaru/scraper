require 'hpricot'
require 'open-uri'

require File.join(File.dirname(__FILE__), '..', 'lib/scraper/link')

class Scraper
  include Scrape
  
  attr_accessor :url
  
  # Scrapes a web page, collecting all links on the page and scraping each new link.
  # Possible options
  # options[:div] - The container div with the links
  # options[:domain] - The domain to collect links from, all other domains are ignored
  # options[:ignore] - An Array of regexes.  Any links matching one will be ignored.
  # options[:recursive] - A boolean.  If false, only get the top level links.  Default is true.
  # options[:self] - A boolean.  Whether to include the main page in results.  Default is true.
  def initialize(url, options = {})
    @url = url
    @options = options
    unless @options.has_key?(:recursive)
      @options.merge!(:recursive => true)
    end
    
    unless @options.has_key?(:self)
      @options.merge!(:self => true)
    end
  end
  
  def scrape(options = {})
    options.merge!(@options)
    links = [Link.new(self.url)]
    
    until (not_visited = links.uniq.select { |link| !link.visited }).empty?
      not_visited.each { |link| links += link.scrape!(options) }
      break unless options[:recursive]
    end
    
    links.delete(Link.new(self.url)) unless options[:self]
    
    return links.uniq
  end
end