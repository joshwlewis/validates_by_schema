# validates_by_schema Changelog

All notable changes to validates_by_schema will be documented in this file, starting at
version 0.3.0.

validates_by_schema uses semantic versioning.

## 0.5.2 - 2024-10-29

- Add support for Rails 7.2, drop Ruby 3.0 and Rails 6.1

## 0.5.1 - 2023-02-28

- Improve load time to configure validations.

## 0.5.0 - 2021-11-25

- Validates uniqueness based on database indizes.

## 0.4.0 - 2019-10-31

- Do not load schema on class definition, add validations when schema is loaded.
- Add support for ActiveRecord 6.0.
- Remove support for ActiveRecord 4.2.

## 0.3.1 - 2018-05-16

- Fix issue on rake db:create for Rails 5.2

## 0.3.0 - 2015-11-10

- Add support for ActiveRecord 4.2.
- No longer validating numericality for enums.
- No longer validating numericality for decimals without precision.
- No longer validating primary, foreign keys, or timestamps.
