module Stripe
  module CLI
    module Commands
      class BalanceTransactions < Command
        desc "list", "List transactions"
        option :count
        option :offset

        def list
          super Stripe::BalanceTransaction, options
        end

        desc "find ID", "Find a transaction"
        def find transaction_id
          super Stripe::BalanceTransaction, transaction_id
        end
      end
    end
  end
end