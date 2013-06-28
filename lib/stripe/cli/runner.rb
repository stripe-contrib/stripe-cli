module Stripe
  module CLI
    class Runner < Thor
      register Commands::Charges, 'charges', 'charges', '/charges'
    end
  end
end