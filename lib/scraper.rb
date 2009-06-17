require 'hpricot'
require 'open-uri'

require 'scraper/link'

class Scraper
  attr_accessor :url, :visited
  
  def initialize(url)
    self.url = url
    self.visited = false
  end
end