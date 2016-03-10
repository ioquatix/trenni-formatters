# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'trenni/formatters/version'

Gem::Specification.new do |spec|
	spec.name          = "trenni-formatters"
	spec.version       = Trenni::Formatters::VERSION
	spec.authors       = ["Samuel Williams"]
	spec.email         = ["samuel.williams@oriontransfer.co.nz"]
	spec.description   = <<-EOF
	Trenni is a templating system, and these formatters assist with the development
	of typical view and form based web interface. A formatter is a high-level
	adapter that turns model data into presentation text.

	Formatters are designed to be customised, typically per-project, for specific
	formatting needs.
	EOF
	spec.summary       = %q{Formatters for Trenni, to assist with typical views and form based interfaces.}
	spec.homepage      = "https://github.com/ioquatix/trenni-formatters"

	spec.files         = `git ls-files`.split($/)
	spec.executables   = spec.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
	spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
	spec.require_paths = ["lib"]
	
	spec.add_dependency "trenni", "~> 1.5.0"
	
	spec.add_dependency "mapping", "~> 1.0.0"
	
	spec.add_development_dependency "bundler", "~> 1.3"
	spec.add_development_dependency "rspec", "~> 3.4.0"
	spec.add_development_dependency "rake"
end
