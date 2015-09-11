# Validates By Schema (validates_by_schema)
[![Build Status](https://secure.travis-ci.org/joshwlewis/validates_by_schema.png)](http://travis-ci.org/joshwlewis/validates_by_schema)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/joshwlewis/validates_by_schema)
[![Dependency Status](https://gemnasium.com/joshwlewis/validates_by_schema.png)](https://gemnasium.com/joshwlewis/validates_by_schema)
[![Gem Version](https://badge.fury.io/rb/validates_by_schema.png)](http://badge.fury.io/rb/validates_by_schema)

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

## Notes

Column properties are inferred by your database adapter (like pg, mysql2, sqlite3), and does not depend on migration files or schema.rb. As such, you could use this on projects where the database where Rails is not in control of the database configuration.

This has been tested with mysql, postgresql, and sqlite3. It should work with any other database that has reliable adapter.
