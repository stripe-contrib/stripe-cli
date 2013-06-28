module Stripe
  module CLI
    class Runner < Thor
      register Commands::Charges, 'charges', 'charges', '/charges'
      register Commands::Customers, 'customers', 'customers', '/customers'
      register Commands::Plans, 'plans', 'plans', '/plans'
      register Commands::Events, 'events', 'events', '/events'
    end
  end
end