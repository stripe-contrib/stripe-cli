module Stripe
  module CLI
    module Commands
      class Transfers < Command
        include Stripe::Utils

        desc "list", "List transfers, optionaly filter by recipient or transfer status: ( pending paid failed )"
        option :starting_after, :desc => "The ID of the last object in the previous paged result set. For cursor-based pagination."
        option :ending_before, :desc => "The ID of the first object in the previous paged result set, when paging backwards through the list."
        option :limit, :desc => "a limit on the number of resources returned, between 1 and 100"
        option :offset, :desc => "the starting index to be used, relative to the entire list"
        option :count, :desc => "deprecated: use limit"
        option :recipient, :desc => "limit result set to RECIPIENT's transfers"
        option :status, :desc => "filter by transfer status: ( pending paid failed )", :enum => %w( pending paid failed )
        def list
          super Stripe::Transfer, options
        end

        desc "find ID", "Find a transfer"
        def find transfer_id
          super Stripe::Transfer, transfer_id
        end

        desc "create", "create a new outgoing money transfer"
        option :amount, :desc => "transfer amount in dollars (or cents when --no-dollar-amounts)"
        option :recipient, :desc => "ID of transfer recipient. May also be created interactively."
        option :currency, :default => 'usd'
        option :description, :desc => "Arbitrary description of transfer"
        option :statement_description, :desc => "Displayed alongside your company name on your customer's card statement (15 character max)"
        option :balance, :type => :boolean, :desc => "Sugar for specifying that amount should be equal to current balance"
        option :self, :type => :boolean, :desc => "Sugar for specifying a transfer into your own account"
        option :metadata, :type => :hash, :desc => "a key/value store of additional user-defined data"
        def create
          if options.delete(:balance) == true
            options[:amount] = Stripe::Balance.retrieve(api_key).available.first.amount
          else
            options[:amount] = convert_amount(options[:amount])
          end

          if options.delete(:self) == true
            options[:recipient] = 'self'
          else
            options[:recipient] ||= ask('Recipient ID or self:')
            options[:recipient] = create_recipient[:id] if options[:recipient] == ""
          end

          super Stripe::Transfer, options
        end

        private

        def create_recipient
          Stripe::CLI::Runner.start [ "recipients", "create" ]
        end
      end
    end
  end
end