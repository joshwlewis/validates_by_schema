require 'widget'

class Gizmo < Widget
  load_schema # who knows, probably loaded by somebody else before validates_by_schema

  validates_by_schema only: [:name, :wheels, :cost]
end
