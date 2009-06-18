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
  def initialize(url, options = {})
    @url = url
    @options = options
  end
  
  def scrape(options = {})
    links = [Link.new(self.url)]
    until (not_visited = links.uniq.select { |link| !link.visited }).empty?
      not_visited.each { |link| links += link.scrape!(options.merge(@options)) }
    end
    
    return links.uniq
  end
end