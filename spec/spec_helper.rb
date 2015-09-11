ENV['RAILS_ENV'] ||= 'test'

require 'yaml'
require 'active_record'
require 'shoulda-matchers'
require 'coveralls'

# Start code coverage tracking.
Coveralls.wear!

# Load up our code
require 'validates_by_schema'

# hook up to the database
conf = YAML.load(ERB.new(File.read(File.join(File.dirname(__FILE__), 'config', 'database.yml'))).result)
ActiveRecord::Base.establish_connection(conf['test'])

# Add support test models to the load path.
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'support', 'models'))

# Require all support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

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
