module Stripe
  module CLI
    module Commands
      class BalanceTransactions < Command
        desc "list", "List transactions"
        option :count
        option :offset
        option :type, :enum => %w( charge refund adjustment application_fee application_fee_refund transfer transfer_failure )
        option :source

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