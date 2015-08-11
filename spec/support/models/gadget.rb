require 'widget'

class Gadget < Widget
  validates_by_schema except: :wheels
end
