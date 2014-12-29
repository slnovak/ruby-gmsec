# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gmsec/version'

Gem::Specification.new do |spec|
  spec.name          = 'gmsec'
  spec.version       = GMSEC::VERSION
  spec.authors       = ['Stefan Novak']
  spec.email         = ['stefan@novak.io']
  spec.summary       = %q{Unofficial Ruby wrapper for NASA's GMSEC.}
  spec.description   = %q{Unofficial Ruby wrapper for NASA's GMSEC. For more information, visit http://gmsec.gsfc.nasa.gov/.}
  spec.homepage      = 'http://gmsec.gsfc.nasa.gov/'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'commander', '~> 4.2.1'
  spec.add_development_dependency 'pry', '~> 0.10.1'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.1.0'

  spec.add_dependency 'ffi', '~> 1.9.6'
  spec.add_dependency 'terminal-table', '~> 1.4.5'
end
