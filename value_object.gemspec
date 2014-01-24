# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'value_object/version'

Gem::Specification.new do |spec|
  spec.name          = "value_object"
  spec.version       = ValueObject::VERSION
  spec.authors       = ["Mark IJbema"]
  spec.email         = ["markijbema@gmail.com"]
  spec.description   = %q{Extremely simple value objects}
  spec.summary       = %q{ValueObject is an immutable, named parameters based, replacement for Struct}
  spec.homepage      = "https://github.com/markijbema/value_object"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
