module Stripe
  module CLI
    module Commands
      class Refunds < Command
        include Stripe::Utils

        desc "list", "List refunds for CHARGE charge"
        option :starting_after, :desc => "The ID of the last object in the previous paged result set. For cursor-based pagination."
        option :ending_before, :desc => "The ID of the first object in the previous paged result set, when paging backwards through the list."
        option :limit, :desc => "a limit on the number of resources returned, between 1 and 100"
        option :offset, :desc => "the starting index to be used, relative to the entire list"
        option :count, :desc => "deprecated: use limit"
        option :charge, :aliases => :c, :required => true, :desc => "Id of charge who's refunds we want to list"
        def list
          if charge = retrieve_charge(options.delete :charge)
            super charge.refunds, options
          end
        end

        desc "find ID", "Find ID refund of CHARGE charge"
        option :charge, :aliases => :c, :required => true, :desc => "Id of charge who's refund we want to find"
        def find refund_id
          if charge = retrieve_charge(options.delete :charge)
            super charge.refunds, refund_id
          end
        end

        desc "create", "apply a new refund to CHARGE charge"
        option :amount, :type => :numeric, :desc => "Refund amount in dollars. (or cents when --no-dollar-amounts) defaults to entire charged amount"
        option :metadata, :type => :hash, :desc => "a key/value store of additional user-defined data"
        option :refund_application_fee, :type => :boolean, :default => false, :desc => "Whether or not to refund the application fee"
        option :charge, :aliases => :c, :required => true, :desc => "Id of charge to apply refund"
        def create
          options[:amount] = convert_amount(options[:amount]) if options[:amount]
          if charge = retrieve_charge(options.delete :charge)
            super charge.refunds, options
          end
        end

      end
    end
  end
end
