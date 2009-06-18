module Scrape
  class Link
    attr_accessor :url, :visited, :title
    def initialize(url, title='')
      @url = url
      @title = title
      @visited = false
    end
    
    def scrape!(options = {})
      return [] if @visited
      @visited = true
      return get_links(options)
    end
    
    def ==(other)
      return false unless other.is_a? Link
      @url == other.url
    end
    
    def eql?(other)
      return self == other
    end
    
    def hash
      @url.hash
    end
    
    private
    def get_links(options = {})
      div = nil
      ignore = []
      
      if options[:div]
        div = options[:div]
      end
      
      if options[:ignore]
        ignore = options[:ignore]
      end
      
      links = []
      
      doc = Hpricot(Net::HTTP.get(URI.parse(@url)))
      doc.search("#{div} a").each do |link|
        url = link['href']
        if url =~ /^\/(.*)/
          components = URI::split(@url)
          url = "#{components[0] || 'http'}://#{components[2]}#{url}"
        elsif url =~ /^http:\/\//i
          url = url
        elsif url =~ /file:\/\//
          next
        elsif url =~ /^#/
          url = @url.gsub(/#.*/, '').gsub(/\/$/, '') + url
        else
          url = (File.dirname(@url) + '/' + (url || ''))
        end
        
        # Don't add this link if it matches a pattern in ignore
        skip = false
        ignore.each { |pattern| skip = true if url =~ pattern }
        skip = true if options[:domain] && !url.include?(options[:domain])
        
        links << Link.new(url, link.inner_html) unless skip
      end
      
      return links.uniq
    end
  end
end