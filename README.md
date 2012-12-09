# Validates By Schema

Validate from your database schema. Keep your code DRY. Automatic validations based on your database column type and limits.

## Usage

1. Add it to your Gemfile

```ruby
gem "validates_by_schema", :git => git://github.com/joshwlewis/validates_by_schema.git
```

2. Then `bundle`

3. Add it to your ActiveRecord model

```ruby
class Widget < ActiveRecord::Base
  validates_from_schema
end
```

## Example

Say you had a table setup like this:

```ruby
create_table "shims", :force => true do |t|
  t.integer  "pattern_id",      :null => false
  t.decimal  "thickness",       :precision => 4, :scale => 4
  t.string   "color"
  t.datetime "created_at",                                       :null => false
  t.datetime "updated_at",                                       :null => false
end
```

Then these validations would run (with MySQL at least):
```ruby
  validates :pattern_id, presence: true, numericality {allow_nil: false, less_than: 2147483647}
  validates :thickness, numericality: {allow_nil: true, less_than: 0.999, greater_than: -0.999}
  validates :color, length: {allow_nil: true, maximum: 255}
```

This should support any database supported by Rails. I have only tested MySQL up to this point.