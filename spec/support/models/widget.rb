class Widget < ActiveRecord::Base

  belongs_to :parent, class_name: 'Widget'

end
