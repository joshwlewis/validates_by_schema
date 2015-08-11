module ValidatesBySchema
  autoload :ValidationOption, 'validates_by_schema/validation_option'

  extend ActiveSupport::Concern

  module ClassMethods
    def validates_by_schema(options = {})
      return unless table_exists?

      columns = schema_validateable_columns
      customize_columns(columns, options)
      define_validations(columns)
      define_association_validations
    end

    def schema_validateable_columns
      # Don't auto validate primary, foreign keys or timestamps
      foreign_keys = all_foreign_keys
      columns.reject do |c|
        c.name == primary_key.to_s ||
        %w(updated_at created_at).include?(c.name) ||
        foreign_keys.include?(c.name)
      end
    end

    def customize_columns(columns, options)
      # Allow user to specify :only or :except options
      { only: :select!, except: :reject! }.each do |k, v|
        if options[k]
          attrs = Array(options[k]).collect(&:to_s)
          columns.send(v) { |c| attrs.include?(c.name) }
        end
      end
    end

    def define_validations(columns)
      columns.each do |c|
        vo = ValidationOption.new(c).to_hash
        validates c.name, vo if vo.present?
      end
    end

    def define_association_validations
      reflect_on_all_associations(:belongs_to).each do |association|
        column = columns_hash[association.foreign_key.to_s]
        next unless column
        validates association.name, presence: true unless column.null
      end
    end

    def all_foreign_keys
      reflect_on_all_associations(:belongs_to).collect do |association|
        association.foreign_key.to_s
      end
    end
  end
end

ActiveSupport.on_load :active_record do
  include ValidatesBySchema
end
