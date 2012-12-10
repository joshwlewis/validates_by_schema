module ValidatesBySchema
  extend ActiveSupport::Concern

  module ClassMethods
    def validates_by_schema options={}
      return unless table_exists?
      # Don't auto validated primary keys or timestamps
      columns = self.columns.reject(&:primary)
      columns.reject!{|c| ['updated_at', 'created_at'].include? c.name}

      # Allow user to specify :only or :except options
      except = options.delete(:except).try(:map, &:to_s)
      only = options.delete(:only).try(:map, &:to_s)
      if only.present?
        columns.select!{|c| only.include? c.name}
      elsif except.present?
        columns.reject!{|c| except.include? c.name}
      end

      columns.each do |c|
        case c.type
        when :integer
          val_hash = {presence: !c.null, numericality: { 
            only_integer: true, allow_nil: c.null}}
          if c.limit
            max = (2 ** (8 * c.limit)) / 2
            val_hash[:numericality][:less_than] = max
            val_hash[:numericality][:greater_than] = -max
          end
          validates c.name, val_hash
        when :decimal
          maximum = 10.0**(c.precision-c.scale) - 10.0**(-c.scale)
          validates c.name, presence: !c.null, numericality: { 
            allow_nil: c.null, greater_than_or_equal_to: -maximum,
            less_than_or_equal_to: maximum }
        when :float
          validates c.name, presence: !c.null,
            numericality: { allow_nil: c.null }
        when :string, :text
          val_hash = { presence: !c.null }
          val_hash[:length] = { maximum: c.limit, allow_nil: c.null} if c.limit
          validates c.name, val_hash
        when :boolean
          validates c.name, inclusion: { in: [true, false], 
            allow_nil: c.null }
        when :date, :datetime, :time
          validates c.name, presence: !c.null
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, ValidatesBySchema)
