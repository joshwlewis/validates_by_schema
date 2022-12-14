ENV['RAILS_ENV'] ||= 'test'

require 'yaml'
require 'active_record'
require 'shoulda-matchers'
require 'simplecov'

SimpleCov.start do
  if ENV['CI']
    require 'simplecov-lcov'

    SimpleCov::Formatter::LcovFormatter.config do |c|
      c.report_with_single_file = true
      c.single_report_path = 'coverage/lcov.info'
    end

    formatter SimpleCov::Formatter::LcovFormatter
  end
end

# Load up our code
require 'validates_by_schema'

# Setup the database
conf = nil
begin
  # load with psych 4 (>= ruby 3.1)
  conf = YAML.load(ERB.new(File.read(File.join(File.dirname(__FILE__), 'config', 'database.yml'))).result, aliases: true)
rescue ArgumentError
  # fallback to psych 3 syntax
  conf = YAML.load(ERB.new(File.read(File.join(File.dirname(__FILE__), 'config', 'database.yml'))).result)
end

ActiveRecord::Base.establish_connection(conf['test'])

ActiveRecord::Base.belongs_to_required_by_default = false

load(File.join(File.dirname(__FILE__), 'config', 'schema.rb'))

# Add support test models to the load path.
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'support', 'models'))

# Require all support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  config.include(Shoulda::Matchers::ActiveModel)
  config.include(Shoulda::Matchers::ActiveRecord)
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :active_record
    with.library :active_model
  end
end

module Shoulda
  module Matchers
    module ActiveModel
      class ValidatePresenceOfMatcher < ValidationMatcher
        # monkey patch to use `include?` instead of `in?`
        def collection_association?
          association? && %i[has_many has_and_belongs_to_many].include?(association_reflection.macro)
        end
      end
    end
  end
end
