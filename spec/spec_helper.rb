ENV['RAILS_ENV'] ||= 'test'

require 'yaml'
require 'active_record'
require 'shoulda-matchers'
require 'validates_by_schema'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'support', 'models'))

conf = YAML.load(ERB.new(File.read(File.join(File.dirname(__FILE__), 'config', 'database.yml'))).result)
ActiveRecord::Base.establish_connection(conf['test'])

load(File.join(File.dirname(__FILE__), 'config', 'schema.rb'))

RSpec.configure do |config|
  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      fail ActiveRecord::Rollback
    end
  end

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end
