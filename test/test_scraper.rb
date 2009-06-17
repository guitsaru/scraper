require 'test_helper'

class TestScraper < Test::Unit::TestCase
  include Scrape
  
  context "initialization" do
    setup do
      @scraper = Scraper.new('http://example.com')
    end

    should "set the url" do
      assert_equal('http://example.com', @scraper.url)
    end
  end
  
  context "scraping" do
    setup do
      @scraper = Scraper.new('http://example.com/main.html')
      @results = @scraper.scrape('#content')
    end
    
    should "Include a list of links on the pages." do
      assert(@results.include?(Link.new('http://example.com/first_page.html')))
      assert(@results.include?(Link.new('http://example.com/first_child_page.html')))
      assert(@results.include?(Link.new('http://google.com')))
    end
    
    should "Not include any links outside of the content div" do
      assert(!@results.include?(Link.new('http://example.com/not_added.html')))
    end
  end
end
