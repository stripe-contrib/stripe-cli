# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stripe/cli/version'

Gem::Specification.new do |spec|
  spec.name          = "stripe-cli"
  spec.version       = Stripe::CLI::VERSION
  spec.authors       = ["Alex MacCaw", "Andy Cohen"]
  spec.email         = ["alex@stripe.com", "outlawandy@gmail.com"]
  spec.description   = %q{Command line access to all of the Stripe API}
  spec.summary       = %q{Command line interface to Stripe}
  spec.homepage      = "https://stripe.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.bindir        = 'bin'
  spec.executables  << 'stripe'
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.executables   = ["stripe"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_dependency "thor", "~> 0.18.1"
  spec.add_dependency "stripe", "~> 1.8.8"
  spec.add_dependency "awesome_print"
  spec.add_dependency "parseconfig"
  spec.add_dependency "chronic"
end