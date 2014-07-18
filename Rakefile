require 'bundler/gem_tasks'
require 'appraisal'
require 'rspec/core/rake_task'
require 'cucumber/rake/task'

if !ENV['APPRAISAL_INITIALIZED'] && !ENV['TRAVIS']
  task default: :appraisal
end

desc 'Test the paperclip plugin.'
RSpec::Core::RakeTask.new(:spec)

desc 'Run integration test'
Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = %w(--format progress)
end
