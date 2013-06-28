module Stripe
  module CLI
    module Commands
      autoload :Charges, 'stripe/cli/commands/charges'
      autoload :Customers, 'stripe/cli/commands/customers'
      autoload :Plans, 'stripe/cli/commands/plans'
      autoload :Events, 'stripe/cli/commands/events'
    end
  end
end