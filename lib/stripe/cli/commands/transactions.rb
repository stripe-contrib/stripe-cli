module Stripe
  module CLI
    module Commands
      class Transactions < Command

        desc "list [TYPE]", "List transactions, optionaly filter by type: ( charges, refunds, adjustments, application_fees, application_fee_refunds, transfers, transfer_failures )"
        option :starting_after, :desc => "The ID of the last object in the previous paged result set. For cursor-based pagination."
        option :ending_before, :desc => "The ID of the first object in the previous paged result set, when paging backwards through the list."
        option :limit, :desc => "a limit on the number of resources returned, between 1 and 100"
        option :offset, :desc => "the starting index to be used, relative to the entire list"
        option :count, :desc => "depricated: use limit"
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