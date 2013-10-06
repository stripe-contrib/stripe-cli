module Stripe
  module CLI
    module Commands
      class Balance < Command
        desc "current", "show currently available and pending balance figures"
        def current
          request Stripe::Balance, :retrieve, api_key
        end

        default_command :current
      end
    end
  end
end