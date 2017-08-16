# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stripe/cli/version'

Gem::Specification.new do |spec|
  spec.name          = 'stripe-cli'
  spec.version       = Stripe::CLI::VERSION
  spec.authors       = ['Alex MacCaw', 'Andy Cohen']
  spec.email         = ['alex@stripe.com', 'outlawandy@gmail.com']
  spec.description   = <<-DESC.gsub("\t","")
  a git-style cli, offering a friendly, intuitive interface to all of the Stripe API right from the console.
  With an emphasis on convenience and productivity and a commitment to pretty, colorful, but most of all READABLE output.
  DESC
  spec.summary       = %q{Command line interface to Stripe}
  spec.homepage      = 'https://stripe.com'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/).delete_if{ |f| 'png' == f[/\.(.*)$/,1] }# don't include example images
  spec.bindir        = 'bin'
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.executables   = ['stripe']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rspec', '~> 2.12', '>= 2.12.0'
  spec.add_runtime_dependency 'thor', '~> 0.18', '>= 0.18.1'
  spec.add_runtime_dependency 'stripe', '~> 2.11.0', '>= 2.11.0'
  spec.add_runtime_dependency 'awesome_print', '~> 1.7', '>= 1.7.0'
  spec.add_runtime_dependency 'parseconfig', '~> 1.0', '>= 1.0.4'
  spec.add_runtime_dependency 'chronic', '~> 0.10', '>= 0.10.2'
end
