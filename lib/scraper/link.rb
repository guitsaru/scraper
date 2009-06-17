module Scrape
  class Link
    attr_accessor :url, :visited, :title
    def initialize(url, title='')
      @url = url
      @title = title
      @visited = false
    end
    
    def scrape!(div=nil)
      return [] if @visited
      @visited = true
      return get_links(div)
    end
    
    def ==(other)
      return false unless other.is_a? Link
      @url == other.url
    end
    
    private
    def get_links(div)
      links = []
      
      doc = Hpricot(Net::HTTP.get(URI.parse(url)))
      doc.search("#{div} a").each do |link|
        url = link['href']
        if url =~ /^\/(.*)/
          components = URI::split(@url)
          url = "#{components[0] || 'http'}://#{components[2]}/url"
        elsif url =~ /^http:\/\//i
          url = url
        else
          url = (File.dirname(@url) + '/' + (url || ''))
        end
        
        links << Link.new(url, link.inner_html)
      end
      
      return links.uniq
    end
  end
end