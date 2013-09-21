module Stripe
  module CLI
    class Runner < Thor
      register Commands::Charges, 'charges', 'charges', '/charges'
      register Commands::Customers, 'customers', 'customers', '/customers'
      register Commands::Tokens, 'tokens', 'tokens', '/tokens'
      register Commands::Plans, 'plans', 'plans', '/plans'
      register Commands::Coupons, 'coupons', 'coupons', '/coupons'
      register Commands::Events, 'events', 'events', '/events'
      register Commands::Invoices, 'invoices', 'invoices', '/invoices'
      register Commands::BalanceTransactions, 'balance_transactions', 'balance_transactions', '/balance_transactions'
      register Commands::Recipients, 'recipients', 'recipients', '/recipients'
    end
  end
end