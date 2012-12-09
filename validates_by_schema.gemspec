$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "validates_by_schema/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "validates_by_schema"
  s.version     = ValidatesBySchema::VERSION
  s.authors     = ["Josh Lewis"]
  s.email       = ["josh.w.lewis@gmail.com"]
  s.homepage    = "http://www.emergentcoils.com"
  s.summary     = "Default validation for ActiveRecord based on database column attributes"
  s.description = "Validate based on database column attributes! Automagically validate presence, length, numericality, inclusion, and timeliness of ActiveRecord columns."

  s.files = Dir["{lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 3.1.0"
  s.add_dependency "validates_timeliness", "~> 3.0.14"
end
