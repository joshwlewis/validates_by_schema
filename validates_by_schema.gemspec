$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'validates_by_schema/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'validates_by_schema'
  s.version     = ValidatesBySchema::VERSION
  s.authors     = ['Josh Lewis', 'Pascal Zumkehr']
  s.email       = ['josh.w.lewis@gmail.com', 'pascal@codez.ch']
  s.homepage    = 'https://github.com/joshwlewis/validates_by_schema'
  s.summary     = 'Automatic validation based on your database schema column types and limits.'
  s.description = 'Keep your code DRY by inferring column validations from table properties! ' \
                  'Automagically validate presence, length, numericality, inclusion and ' \
                  'uniqueness of ActiveRecord backed columns.'
  s.license     = 'MIT'

  s.metadata['homepage_uri'] = s.homepage
  s.metadata['source_code_uri'] = 'https://github.com/joshwlewis/validates_by_schema'
  s.metadata['changelog_uri'] = 'https://github.com/joshwlewis/validates_by_schema/blob/master/CHANGELOG.md'

  s.files = Dir['{lib}/**/*'] + ['MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['spec/**/*']
  s.require_paths = ['lib']

  s.add_dependency 'activerecord', '>= 7.0.0'

  s.add_development_dependency 'mysql2'
  s.add_development_dependency 'pg'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'sqlite3'
end
