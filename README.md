# Validates By Schema (validates_by_schema)
[![Build Status](https://secure.travis-ci.org/joshwlewis/validates_by_schema.png)](http://travis-ci.org/joshwlewis/validates_by_schema) 

Automatic validation based on your database schema column types and limits. Keep your code DRY by inferring column validations from table properties!

## Usage

1. Add it to your Gemfile:
```ruby
gem "validates_by_schema", :git => git://github.com/joshwlewis/validates_by_schema.git
```

2. Then `bundle`

3. Add it to your ActiveRecord model:
```ruby
class Widget < ActiveRecord::Base
  validates_from_schema
end
```

## Example

Say you had a table setup like this:
```ruby
create_table "widgets", :force => true do |t|
  t.integer  "wheel_count",      :null => false
  t.decimal  "thickness",       :precision => 4, :scale => 4
  t.string   "color"
end
```

Then these validations run when your model `validates_from_schema`:
```ruby
  validates :wheel_count, presence: true, numericality {allow_nil: false, less_than: 2147483647}
  validates :thickness, numericality: {allow_nil: true, less_than: 0.999, greater_than: -0.999}
  validates :color, length: {allow_nil: true, maximum: 255}
```

This should support any database supported by Rails. I have only tested MySQL up to this point.