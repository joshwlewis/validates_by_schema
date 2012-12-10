class Gizmo < Widget
  validates_by_schema only: [:name, :wheels, :cost]
end