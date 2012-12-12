$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "validates_by_schema/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "validates_by_schema"
  s.version     = ValidatesBySchema::VERSION
  s.authors     = ["Josh Lewis"]
  s.email       = ["josh.w.lewis@gmail.com"]
  s.homepage    = "http://github.com/joshwlewis/validates_by_schema"
  s.summary     = "Automatic validation based on your database schema column types and limits."
  s.description = "Keep your code DRY by inferring column validations from table properties! Automagically validate presence, length, numericality, and inclusion of ActiveRecord backed columns."

  s.files = Dir["{lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]
  s.require_paths = ["lib"]

  s.add_dependency "rails", ">= 3.1.0"

  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "shoulda-matchers"
  s.add_development_dependency "sqlite3"
end
