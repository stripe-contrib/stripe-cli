require "thor"
require "stripe"
require "stripe/cli/version"
require "awesome_print"
require "stripe/utils"

module Stripe
  module CLI
    autoload :Command, 'stripe/cli/command'
    autoload :Runner, 'stripe/cli/runner'
    autoload :Commands, 'stripe/cli/commands'
  end

  # `alias_method_chain' style patch to tweek the user-agent header sent with every API request
  # Doing this adds context to request data that can be viewed using the Stripe Dashboard
  # Differentiating requests made by application code from those made using the Stripe-CLI gem
  class<<self
    def add_stripe_cli_to_user_agent_string api_key
      user_agent = original_request_headers(api_key)[:user_agent]
      original_request_headers(api_key).update(:user_agent => user_agent<<"/Stripe-CLI v#{Stripe::CLI::VERSION}")
    end
    alias_method :original_request_headers, :request_headers
    alias_method :request_headers, :add_stripe_cli_to_user_agent_string
    private :request_headers
  end
end
