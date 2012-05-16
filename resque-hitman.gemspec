# -*- encoding: utf-8 -*-
require File.expand_path('../lib/resque/hitman/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Andy Delcambre"]
  gem.email         = ["adelcambre@engineyard.com"]
  gem.description   = %q{A resque plugin to kill jobs}
  gem.summary       = %q{This is a resque plugin that uses redis as an api to kill a job that a worker is currently working on.}
  gem.homepage      = "http://github.com/adelcambre/resque-hitman"

  gem.files         = `git ls-files`.split($\)
  gem.name          = "resque-hitman"
  gem.require_paths = ["lib"]
  gem.version       = Resque::Hitman::VERSION

  gem.add_dependency "resque"
end
