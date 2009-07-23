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
        elsif url =~ /^https?:\/\//i
                  url = url
        elsif url =~ /file:\/\//
          next
        elsif url =~ /^#/
          url = @url.gsub(/#.*/, '').gsub(/\/$/, '') + url
        else
          if @url =~ /\/$/
            url = @url + (url || '')
          else
            url = (File.dirname(@url) + '/' + (url || ''))
          end
        end
        
        # Don't add this link if it matches a pattern in ignore
        skip = false
        ignore.each { |pattern| skip = true if url =~ pattern }
        skip = true if options[:domain] && !url.include?(options[:domain])
        
        if !skip
          new_link = Link.new(url, link.inner_html.strip)
          
          # Don't visit anchors, visit the main page instead.
          if url =~ /(https?:\/\/.*)#(.*$)/i
            links << Link.new($1, $2)
            new_link.visited = true
          end
          
          links << new_link
        end
      end
      
      return links.uniq
    end
  end
end