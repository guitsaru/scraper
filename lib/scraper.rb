require 'hpricot'
require 'open-uri'

require File.join(File.dirname(__FILE__), '..', 'lib/scraper/link')

class Scraper
  include Scrape
  
  attr_accessor :url
  
  def initialize(url)
    self.url = url
  end
  
  def scrape(div=nil)
    links = [Link.new(self.url)]
    until (not_visited = links.uniq.select { |link| !link.visited}).empty?
      not_visited.each { |link| links += link.scrape!(div) }
    end
    
    return links.uniq
  end
end