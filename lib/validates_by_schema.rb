require 'active_support/concern'
require 'active_support/lazy_load_hooks'

module ValidatesBySchema
  autoload :ValidationOption, 'validates_by_schema/validation_option'

  extend ActiveSupport::Concern

  mattr_accessor :validate_uniqueness
  self.validate_uniqueness = true

  module ClassMethods

    def validates_by_schema(options = {})
      @validates_by_schema_options = options
      define_schema_validations if schema_loaded?
    end

    def load_schema!
      super
      # Set flag here to avoid infinite recursion
      @schema_loaded = true

      # define schema validations lazy to avoid accessing the database
      # at class load time.
      define_schema_validations
    end

    private

    def define_schema_validations
      return unless @validates_by_schema_options

      unique_indexes = ValidatesBySchema.validate_uniqueness ? fetch_unique_indexes : []
      customized_schema_validatable_columns.each do |c|
        ValidationOption.new(self, c, unique_indexes).define!
      end

      @validates_by_schema_options = nil
    end

    def fetch_unique_indexes
      connection.schema_cache.indexes(table_name).select(&:unique)
    end

    def customized_schema_validatable_columns
      # Allow user to specify :only or :except options
      schema_validatable_columns.tap do |columns|
        { only: :select!, except: :reject! }.each do |k, v|
          if @validates_by_schema_options[k]
            attrs = Array(@validates_by_schema_options[k]).collect(&:to_s)
            columns.send(v) { |c| attrs.include?(c.name) }
          end
        end
      end
    end

    def schema_validatable_columns
      columns.reject do |c|
        ignored_columns_for_validates_by_schema.include?(c.name)
      end
    end

    def ignored_columns_for_validates_by_schema
      ['id', 'created_at', 'updated_at', 'deleted_at']
    end

  end
end

ActiveSupport.on_load :active_record do
  include ValidatesBySchema
end
