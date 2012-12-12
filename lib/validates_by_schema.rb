module ValidatesBySchema
  autoload :ValidationOption, 'validates_by_schema/validation_option'

  extend ActiveSupport::Concern

  module ClassMethods
    def validates_by_schema options={}
      return unless table_exists?
      # Don't auto validate primary keys or timestamps
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
        vo = ValidationOption.new(c).to_hash
        validates c.name, vo if vo.present?
      end
    end
  end
end

ActiveSupport.on_load :active_record do
  include ValidatesBySchema
end
