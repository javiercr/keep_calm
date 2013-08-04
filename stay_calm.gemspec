# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stay_calm/version'

Gem::Specification.new do |spec|
  spec.name          = "stay_calm"
  spec.version       = StayCalm::VERSION
  spec.authors       = ["Javier Cuevas"]
  spec.email         = ["javi@diacode.com"]
  spec.description   = %q{A simple gem to perform pull backups}
  spec.summary       = %q{A simple gem to perform pull backups}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_dependency "net-ssh"
end
