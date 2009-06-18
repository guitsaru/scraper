require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'fakeweb'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'scraper'

class Test::Unit::TestCase
  FakeWeb.register_uri(:get, "http://example.com/main.html", :file => File.join(File.dirname(__FILE__), 'fake_pages/main.html'))
  FakeWeb.register_uri(:get, "http://example.com/first_page.html", :file => File.join(File.dirname(__FILE__), 'fake_pages/first_page.html'))
  FakeWeb.register_uri(:get, "http://example.com/first_child_page.html", :file => File.join(File.dirname(__FILE__), 'fake_pages/first_child_page.html'))
  FakeWeb.register_uri(:get, "http://example.com/not_added.html", :file => File.join(File.dirname(__FILE__), 'fake_pages/not_added.html'))
  FakeWeb.register_uri(:get, "http://google.com", :file => File.join(File.dirname(__FILE__), 'fake_pages/google.html'))
end

