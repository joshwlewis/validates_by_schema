class Gadget < Widget
  validates_by_schema :except => [:description, :wheels, :price]
end