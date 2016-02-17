# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redis_startup/version'

Gem::Specification.new do |spec|
  spec.name          = "redis_startup"
  spec.version       = RedisStartup::VERSION
  spec.authors       = ["Andy Ganchrow"]
  spec.email         = ["andy@ganchrow.com"]

  spec.summary       = %q{Uses EM::Iterator to load data aynschonrously before arbitrary application state.}
  spec.description   = %q{Uses EM::Iterator to load data aynschonrously before arbitrary application state.}
  spec.homepage      = "http://bitbucket.org/andy_ganchrow/redis_startup.git"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|bin)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'kim', '~> 0.5'
  spec.add_dependency 'yajl-ruby', '~> 1.2'
  spec.add_dependency 'em-hiredis', '~> 0.3'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end
