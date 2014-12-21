# coding: utf-8
$:.push File.expand_path("../lib", __FILE__)
require 'mighty_grid/version'

Gem::Specification.new do |s|
  s.name                  = 'mighty_grid'
  s.version               = MightyGrid.gem_version
  s.authors               = ['jurrick']
  s.email                 = ['jurianp@gmail.com']
  s.summary               = %q(Simple and flexible grid for Rails)
  s.description           = %q(Simple and flexible grid for Rails)
  s.homepage              = 'http://github.com/jurrick/mighty_grid'
  s.license               = 'MIT'
  s.required_ruby_version = '~> 2.0'

  s.files                 = Dir["{app,config,lib,vendor}/**/*"] + ["LICENSE.txt", "README.md", "Gemfile", "Rakefile"]
  s.test_files            = Dir["{spec,features}/**/*"]
  s.require_paths         = ['lib']

  s.add_development_dependency 'bundler', '~> 1.5'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec-rails', '~> 2.14.2'
  s.add_development_dependency 'appraisal'

  s.add_dependency 'kaminari', '~> 0.15'
end
