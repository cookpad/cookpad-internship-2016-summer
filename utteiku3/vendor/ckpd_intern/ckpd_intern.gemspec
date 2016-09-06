$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ckpd_intern/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ckpd_intern"
  s.version     = CkpdIntern::VERSION
  s.authors     = ["moro"]
  s.email       = ["kyosuke-morohashi@cookpad.com"]
  s.homepage    = "https://github.com/cookpad/cookpad-internship-2016-summer"
  s.summary     = "Helpers for Cookpad Summer Intern 2016"
  s.description = "Helpers for Cookpad Summer Intern 2016"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.0"
  s.add_dependency "nokogiri"

  s.add_development_dependency "sqlite3"
end
