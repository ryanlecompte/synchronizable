# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "synchronizable/version"

Gem::Specification.new do |s|
  s.name        = "synchronizable"
  s.version     = Synchronizable::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ryan LeCompte"]
  s.email       = ["lecompte@gmail.com"]
  s.homepage    = "http://github.com/ryanlecompte/synchronizable"
  s.summary     = %q{Synchronizable provides a generic mechanism to provide per-object thread safety}
  s.description = %q{Synchronizable provides a generic mechanism to provide per-object thread safety}

  s.rubyforge_project = "synchronizable"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency("rspec", "~> 2.5.0")
end
