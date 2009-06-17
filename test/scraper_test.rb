require 'test_helper'

class ScraperTest < Test::Unit::TestCase
  context "initialization" do
    setup do
      @scraper = Scraper.new('http://example.com')
    end

    should "set the url" do
      assert_equal('http://example.com', @scraper.url)
    end
    
    should "set the visited flag" do
      assert_equal(false, @scraper.visited)
    end
  end
end
