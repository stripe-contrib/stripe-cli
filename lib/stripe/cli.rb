require "thor"
require "stripe"
require "stripe/cli/version"
require "awesome_print"

module Stripe
  module CLI
    autoload :Command, 'stripe/cli/command'
    autoload :Runner, 'stripe/cli/runner'
    autoload :Commands, 'stripe/cli/commands'
  end
end
