class Widget < ActiveRecord::Base
	attr_accessible(*self.columns.map{|c| c.name.to_sym})

end