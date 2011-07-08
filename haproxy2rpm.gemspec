# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "haproxy2rpm/version"

Gem::Specification.new do |s|
  s.name        = "haproxy2rpm"
  s.version     = Haproxy2Rpm::VERSION
  s.authors     = ["Patrick Huesler"]
  s.email       = ["patrick.huesler@gmail.com"]
  s.homepage    = ""
  s.summary     = "Sending haproxy logs to new relic rpm"
  s.description = "Sending haproxy logs to new relic rpm"
  s.add_dependency "newrelic_rpm"
  s.add_dependency "eventmachine-tail"
  s.add_development_dependency "shoulda-context"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
