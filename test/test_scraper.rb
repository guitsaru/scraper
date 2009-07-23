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
      @scraper = Scraper.new('http://example.com/main.html', :recursive => false)
      @results = @scraper.scrape
    end
    
    should "Include a list of links on the pages." do
      assert(@results.include?(Link.new('http://example.com/first_page.html')))
      assert(@results.include?(Link.new('http://example.com/not_added.html')))
    end
  end
  
    context "scraping from folder" do
    setup do
      @scraper = Scraper.new('http://example.com/folder/', :recursive => false)
      @results = @scraper.scrape
    end
    
    should "Include a list of links on the pages." do
      assert(@results.include?(Link.new('http://example.com/folder/first_page.html')))
      assert(@results.include?(Link.new('http://example.com/folder/not_added.html')))
    end
  end
  
  context "scraping with div" do
    setup do
      @scraper = Scraper.new('http://example.com/main.html')
      @results = @scraper.scrape(:div => '#content')
    end
    
    should "Include a list of links on the pages." do
      assert(@results.include?(Link.new('http://example.com/first_page.html')))
      assert(@results.include?(Link.new('http://example.com/first_child_page.html')))
      assert(@results.include?(Link.new('http://example.com/first_child_page.html#content')))
      assert(@results.include?(Link.new('http://example.com/first_child_page.html#content2')))
      assert(@results.include?(Link.new('http://example.com/main.html')))
      assert(@results.include?(Link.new('http://google.com')))
    end
    
    should "Not include any links outside of the content div" do
      assert(!@results.include?(Link.new('http://example.com/not_added.html')))
    end
  end
  
  context "scraping within domain" do
    setup do
      @scraper = Scraper.new('http://example.com/main.html', :domain => 'example.com')
      @results = @scraper.scrape(:div => '#content')
    end
    
    should "Include a list of links on the pages." do
      assert(@results.include?(Link.new('http://example.com/first_page.html')))
      assert(@results.include?(Link.new('http://example.com/first_child_page.html')))
      assert(@results.include?(Link.new('http://example.com/first_child_page.html#content')))
      assert(@results.include?(Link.new('http://example.com/first_child_page.html#content2')))
      assert(@results.include?(Link.new('http://example.com/main.html')))
    end
    
    should "Not include any links outside of the content div" do
      assert(!@results.include?(Link.new('http://example.com/not_added.html')))
    end
    
    should "Not include any links outside of the domain" do
      assert(!@results.include?(Link.new('http://google.com')))
    end
  end
  
  context "Non-recursive scraping" do
    setup do
      @scraper = Scraper.new('http://example.com/main.html', :recursive => false)
      @results = @scraper.scrape(:div => '#content')
    end

    should "include top level links" do
      assert(@results.include?(Link.new('http://example.com/first_page.html')))
    end
    
    should "not include recursive links" do
      assert(!@results.include?(Link.new('http://example.com/first_child_page.html')))
      assert(!@results.include?(Link.new('http://example.com/first_child_page.html#content')))
      assert(!@results.include?(Link.new('http://example.com/first_child_page.html#content2')))
    end
  end
  
    context "Scraping without self" do
    setup do
      @scraper = Scraper.new('http://example.com/main.html', :self => false)
      @results = @scraper.scrape(:div => '#content')
    end

    should "not include self" do
      assert(!@results.include?(Link.new('http://example.com/main.html')))
    end
  end
end
