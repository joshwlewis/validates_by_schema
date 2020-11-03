class Widget < ActiveRecord::Base

  belongs_to :parent, class_name: 'Widget'
  belongs_to :other, class_name: 'Widget', optional: true

end
