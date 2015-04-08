# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cahdmaker/version'

Gem::Specification.new do |spec|
  spec.name          = "cahdmaker"
  spec.version       = Cahdmaker::VERSION
  spec.authors       = ["Michael Klein"]
  spec.email         = ["mbklein@gmail.com"]
  spec.summary       = %q{Make some Misanthropic Cards}
  spec.description   = %q{Make some Misanthropic Cards}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rmagick"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
