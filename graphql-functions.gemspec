# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'graphql/functions/version'

Gem::Specification.new do |spec|
  spec.name          = "graphql-functions"
  spec.version       = GraphQL::Functions::VERSION
  spec.authors       = ["Joaquín Moreira", "Daniel Ortega"]
  spec.email         = ["jmoreira@comparaonline.com", "dortega@comparaonline.com"]

  spec.summary       = %q{Collection of GraphQL functions to give basic active record like support for graphql queries}
  spec.description   = %q{GraphQL functions made to simplify the standard query creation of the graphql gem in your Active Record models.
    Using the provided functions your graphql types will gain standard and generic query arguments to limit the amount of rows, use an offset, or filter by an specific id among others.}
  spec.homepage      = "https://github.com/comparaonline/graphql-ruby-functions"
  spec.license       = "MIT"
  spec.required_ruby_version = '>= 2.2'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.2"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "sqlite3", "~> 1.3"
  spec.add_development_dependency "byebug"

  spec.add_dependency "activerecord", "~> 6.1"
  spec.add_dependency "graphql", "~> 1.5"
end
