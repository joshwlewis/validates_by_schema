#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end
begin
  require 'rdoc/task'
rescue LoadError
  require 'rdoc/rdoc'
  require 'rake/rdoctask'
  RDoc::Task = Rake::RDocTask
end

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'ValidatesBySchema'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = Dir.glob('spec/**/*_spec.rb')
  t.rspec_opts = ['--backtrace']
end

task default: :spec

namespace :db do
  task :drop do
    puts 'dropping'
    case ENV['DB']
    when 'postgresql'
      exec "psql -c 'drop database if exists validates_by_schema_test;' -U postgres -h localhost"
    when 'mysql'
      exec "mysql -e 'drop database if exists validates_by_schema_test;' -u root -h 127.0.0.1"
    end
  end

  task :create do
    puts 'creating'
    case ENV['DB']
    when 'postgresql'
      exec "psql -c 'create database validates_by_schema_test;' -U postgres -h localhost"
    when 'mysql'
      exec "mysql -e 'create database validates_by_schema_test;' -u root -h 127.0.0.1"
    end
  end
end
