require 'contraption'

class CompositeContraption < Widget
  self.primary_key = [:id, :legacy_id]
  self.clear_validators!
  validates_by_schema # recalculate the validations
end
