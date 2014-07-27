require 'appraisal'
require 'rspec/core/rake_task'
require 'cucumber/rake/task'

Bundler::GemHelper.install_tasks

if !ENV['APPRAISAL_INITIALIZED'] && !ENV['TRAVIS']
  task default: :appraisal
end

desc 'Test the paperclip plugin.'
RSpec::Core::RakeTask.new(:spec)

desc 'Run integration test'
Cucumber::Rake::Task.new
