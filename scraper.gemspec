# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{scraper}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matt Pruitt"]
  s.date = %q{2009-07-23}
  s.email = %q{guitsaru@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "lib/scraper.rb",
     "lib/scraper/link.rb",
     "scraper.gemspec",
     "test/fake_pages/first_child_page.html",
     "test/fake_pages/first_page.html",
     "test/fake_pages/google.html",
     "test/fake_pages/main.html",
     "test/fake_pages/not_added.html",
     "test/test_helper.rb",
     "test/test_link.rb",
     "test/test_scraper.rb"
  ]
  s.homepage = %q{http://github.com/guitsaru/scraper}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{scraper}
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{Collects all links on a webpage recursively.}
  s.test_files = [
    "test/test_helper.rb",
     "test/test_link.rb",
     "test/test_scraper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<hpricot>, [">= 0.6.161"])
    else
      s.add_dependency(%q<hpricot>, [">= 0.6.161"])
    end
  else
    s.add_dependency(%q<hpricot>, [">= 0.6.161"])
  end
end
