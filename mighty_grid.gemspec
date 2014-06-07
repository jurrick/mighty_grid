# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mighty_grid/version'

Gem::Specification.new do |spec|
  spec.name          = "mighty_grid"
  spec.version       = MightyGrid::VERSION
  spec.authors       = ["jurrick"]
  spec.email         = ["jurianp@gmail.com"]
  spec.summary       = %q{Flexible grid for Rails}
  spec.description   = %q{Flexible grid for Rails}
  spec.homepage      = "http://github.com/jurrick/mighty_grid"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec-rails", "~> 2.14.2"
  spec.add_development_dependency 'appraisal'

  spec.add_dependency 'kaminari', '~> 0.15.0'
end
