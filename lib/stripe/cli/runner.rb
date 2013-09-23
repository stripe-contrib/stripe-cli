module Stripe
  module CLI
    class Runner < Thor
      register Commands::Charges, 'charges', 'charges', 'find, list, create, capture, & refund charges'
      register Commands::Customers, 'customers', 'customers', 'find, list, create, & delete customers'
      register Commands::Tokens, 'tokens', 'tokens', 'find & create tokens for bank accounts & credit cards'
      register Commands::Plans, 'plans', 'plans', 'find, list, create, & delete plans'
      register Commands::Coupons, 'coupons', 'coupons', 'find, list, create, & delete coupons'
      register Commands::Events, 'events', 'events', 'find & list events'
      register Commands::Invoices, 'invoices', 'invoices', 'find, list, pay, and close invoices'
      register Commands::Transactions, 'transactions', 'transactions', 'find & list balance transactions'
      register Commands::Balance, 'balance', 'balance', 'show currently available and pending balance amounts'
      register Commands::Recipients, 'recipients', 'recipients', 'list, find, create & delete recipients'
    end
  end
end