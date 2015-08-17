module ValidatesBySchema
  autoload :ValidationOption, 'validates_by_schema/validation_option'

  extend ActiveSupport::Concern

  module ClassMethods

    def validates_by_schema(options = {})
      return unless table_exists?

      customized_columns(options).each do |c|
        ValidationOption.new(self, c).define!
      end
    end

    private

    def customized_columns(options)
      # Allow user to specify :only or :except options
      schema_validateable_columns.tap do |columns|
        { only: :select!, except: :reject! }.each do |k, v|
          if options[k]
            attrs = Array(options[k]).collect(&:to_s)
            columns.send(v) { |c| attrs.include?(c.name) }
          end
        end
      end
    end

    def schema_validateable_columns
      columns.reject do |c|
        ignored_columns_for_validates_by_schema.include?(c.name)
      end
    end

    def ignored_columns_for_validates_by_schema
      [primary_key.to_s, 'created_at', 'updated_at', 'deleted_at']
    end

  end
end

ActiveSupport.on_load :active_record do
  include ValidatesBySchema
end
