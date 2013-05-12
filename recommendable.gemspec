# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "recommendable/version"

Gem::Specification.new do |spec|
  spec.name        = "recommendable"
  spec.version     = Recommendable::VERSION
  spec.summary     = "A Like/Dislike recommendation engine for Ruby apps using Redis"
  spec.description = spec.summary

  spec.files       = Dir["lib/**/*"]

  spec.has_rdoc    = "yard"

  spec.authors     = ["David Celis"]
  spec.email       = %w[david@davidcelispec.com]
  spec.homepage    = "https://davidcelis.github.com/recommendable"

  spec.add_dependency "activesupport", "~> 3.0"
  spec.add_dependency "redis",         "~> 2.2"
  spec.add_dependency "hooks",         "~> 0.2"

  spec.add_development_dependency "minitest"
  spec.add_development_dependency "miniskirt"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "rails", ">= 3.1.0"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "database_cleaner"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "kramdown"
end
