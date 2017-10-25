# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

require 'rspec/core/rake_task'

task :test do
  Rake::Task['db:environment:set'].invoke('test')
  Rake::Task['db:test:prepare'].invoke
  Rake::Task['spec'].execute
end