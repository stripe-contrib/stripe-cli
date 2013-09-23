module Stripe
  module CLI
    module Commands
      class Transactions < Command
        desc "list [TYPE]", "List transactions, optionaly filter by type: ( charges, refunds, adjustments, application_fees, application_fee_refunds, transfers, transfer_failures )"
        method_options [:count, :offset, :type, :source]
        option :count
        option :offset
        option :type, :enum => %w( charge refund adjustment application_fee application_fee_refund transfer transfer_failure )
        option :source

        def list type = 'all'
          options[:type] = type.sub(/s$/,'') unless type == 'all'
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