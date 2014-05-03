require 'bundler'
Bundler::GemHelper.install_tasks

require "bundler/gem_tasks"
require 'appraisal'
require 'rspec/core'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

desc 'Default: run unit tests.'
task :default => "spec:all"

namespace :spec do
  %w(rails_32 rails_40 rails_41).each do |gemfile|
    desc "Run tests against #{gemfile}"
    task gemfile do
      sh "BUNDLE_GEMFILE='gemfiles/#{gemfile}.gemfile' bundle --quiet"
      sh "BUNDLE_GEMFILE='gemfiles/#{gemfile}.gemfile' bundle exec rake -t spec"
    end
  end

  desc "Run all tests"
  task :all do
    %w(rails_32 rails_40 rails_41).each do |gemfile|
      sh "BUNDLE_GEMFILE='gemfiles/#{gemfile}.gemfile' bundle --quiet"
      sh "BUNDLE_GEMFILE='gemfiles/#{gemfile}.gemfile' bundle exec rake spec"
    end
  end
end