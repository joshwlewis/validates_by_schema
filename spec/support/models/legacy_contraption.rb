require 'contraption'

class LegacyContraption < Widget
  self.primary_key = :legacy_id
  self.clear_validators!
  validates_by_schema # recalculate the validations
end
