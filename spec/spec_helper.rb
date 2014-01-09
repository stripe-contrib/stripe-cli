require 'rspec'
require_relative '../lib/stripe/cli.rb'

f = Tempfile.new('config')
f.write "key = stripe-key" and f.rewind
Stripe::CLI::Command.class_variable_set :@@config, f

module Stripe
  def self.execute_request(opts)
    return OpenStruct.new(body: opts.to_json)
  end
end
