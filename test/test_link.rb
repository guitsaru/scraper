require 'test_helper'

class TestLink < Test::Unit::TestCase
  include Scrape
  
  context "initialization" do
    setup do
      @link = Link.new('http://example.com')
    end

    should "set the url" do
      assert_equal('http://example.com', @link.url)
    end
    
    should "set the title" do
      assert_equal('', @link.title)
      assert_equal('title', Link.new('http://example.com', 'title').title)
    end
    
    should "set the visited flag" do
      assert_equal(false, @link.visited)
    end
  end
  
  context "scraping" do
    setup do
      @link = Link.new('http://example.com/main.html')
      @results = @link.scrape!
    end
    
    should "set the visited flag to true" do
      assert(@link.visited, "Link was not visited")
    end
    
    should "return an array of links on the page" do
      assert_not_nil(@results)
      assert(@results.is_a?(Array))
      assert(@results.include?(Link.new('http://example.com/first_page.html')))
      assert(@results.include?(Link.new('http://example.com/not_added.html')))
      assert(@results.include?(Link.new('http://example.com/main.html?action=edit')))
      assert(!@results.include?(Link.new('http://example.com/first_child_page.html/file://fileserver/file.pdf')))
    end
  end
  
  context "scraping inside a div" do
    setup do
      @link = Link.new('http://example.com/main.html')
      @results = @link.scrape!(:div => '#content')
    end

    should "return an array of links on the page" do
      assert_not_nil(@results)
      assert(@results.is_a?(Array))
      assert(@results.include?(Link.new('http://example.com/first_page.html')))
      assert(@results.include?(Link.new('http://example.com/main.html?action=edit')))
    end
    
    should "not return links not in the div" do
      assert(!@results.include?(Link.new('http://example.com/not_added.html')), "Includes a link outside of the correct div.")
    end
  end
  
  context "scraping with ignore options" do
    setup do
      @link = Link.new('http://example.com/main.html')
      @results = @link.scrape!(:div => '#content', :ignore => [/\?/])
    end

    should "return an array of links on the page" do
      assert_not_nil(@results)
      assert(@results.is_a?(Array))
      assert(@results.include?(Link.new('http://example.com/first_page.html')))
      assert(!@results.include?(Link.new('http://example.com/main.html?action=edit')))
    end
    
    should "not return links not in the div" do
      assert(!@results.include?(Link.new('http://example.com/not_added.html')), "Includes a link outside of the correct div.")
    end
  end
  
  should "be equal to another link with the same url" do
    assert(Link.new('http://example.com') == Link.new('http://example.com'))
  end
end
