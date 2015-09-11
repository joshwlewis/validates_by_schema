require 'widget'

class Contraption < Widget
  enum kind: %w(one other)

  validates_by_schema
end
