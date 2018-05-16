# validates_by_schema Changelog

All notable changes to Unitwise will be documented in this file, starting at
version 0.3.0.

Unitwise uses semantic versioning.

## 0.3.1 - 2018-05-16

- Fix issue on rake db:create for Rails 5.2

## 0.3.0 - 2015-11-10

- Add support for ActiveRecord 4.2.
- No longer validating numericality for enums.
- No longer validating numericality for decimals without precision.
- No longer validating primary, foreign keys, or timestamps.
