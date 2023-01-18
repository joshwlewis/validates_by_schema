# Validates By Schema (validates_by_schema)

[![Gem Version](http://img.shields.io/gem/v/validates_by_schema.svg?style=flat)](https://rubygems.org/gems/validates_by_schema)
[![Build Status](http://img.shields.io/github/actions/workflow/status/joshwlewis/validates_by_schema/Build?style=flat)](https://github.com/joshwlewis/validates_by_schema/actions/workflows/build.yml)
[![Coverage Status](http://img.shields.io/coveralls/joshwlewis/validates_by_schema.svg?style=flat)](https://coveralls.io/r/joshwlewis/validates_by_schema)
[![Code Climate](http://img.shields.io/codeclimate/maintainability/joshwlewis/validates_by_schema.svg?style=flat)](https://codeclimate.com/github/joshwlewis/validates_by_schema)

Automatic validation based on your database schema column types and limits. Keep your code DRY by inferring column validations from table properties!

## Example

Say you had a table setup like this:

```ruby
create_table "widgets", force: true do |t|
  t.integer "quantity", limit: 2, null: false
  t.decimal "thickness", precision: 4, scale: 4
  t.string  "color", null: false
  t.boolean "flagged", null: false, default: false
  t.integer "other_id", null: false
  t.index ["other_id", "color"], unique: true
end
```

Then these validations are inferred when you add `validates_by_schema` to your model:

```ruby
validates :quantity, presence: true,
                     numericality: { allow_nil: true,
                                     only_integer: true,
                                     greater_than: -32768,
                                     less_than: 32768}
validates :thickness, numericality: { allow_nil: true,
                                      less_than_or_equal_to: 0.999,
                                      greater_than_or_equal_to: -0.999 }
validates :color, presence: true, length: { allow_nil: true, maximum: 255 }
validates :flagged, inclusion: { in: [true, false], allow_nil: false }
validates :other, presence: true
validates :other_id,
          uniqueness: {
            scope: :color,
            if: -> { |model| model.other_id_changed? || model.color_changed? }
          }
```

## Installation

1. Add it to your Gemfile:

```ruby
gem "validates_by_schema"
```

2. Then `bundle`

3. Call it from your ActiveRecord model:

```ruby
class Widget < ActiveRecord::Base
  validates_by_schema
end
```

## Usage

You can also whitelist or blacklist columns with :only or :except options, respectively:

```ruby
validates_by_schema only: [:body, :description]
```

```ruby
validates_by_schema except: [:name, :title]
```

The primary key and timestamp columns are not validated.

If you want to opt out of automatic uniqueness validations globally, add the following line to an initializer:

```ruby
ValidatesBySchema.validate_uniqueness = false
```

## Notes

Column properties are inferred by your database adapter (like pg, mysql2, sqlite3), and does not depend on migration files or schema.rb. As such, you could use this on projects where the database where Rails is not in control of the database configuration.

This has been tested with mysql, postgresql, and sqlite3. It should work with any other database that has reliable adapter.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/joshwlewis/validates_by_schema.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
