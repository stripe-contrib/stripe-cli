module Stripe
  module CLI
    module Commands
      class Transfers < Command

        desc "list", "List transfers, optionaly filter by recipient or transfer status: ( pending paid failed )"
        option :starting_after, :desc => "The ID of the last object in the previous paged result set. For cursor-based pagination."
        option :ending_before, :desc => "The ID of the first object in the previous paged result set, when paging backwards through the list."
        option :limit, :desc => "a limit on the number of resources returned, between 1 and 100"
        option :offset, :desc => "the starting index to be used, relative to the entire list"
        option :count, :desc => "depricated: use limit"
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
        option :amount
        option :recipient
        option :currency, :default => 'usd'
        option :description
        option :statement_descriptor
        option :balance, :type => :boolean
        option :self, :type => :boolean
        option :metadata, :type => :hash
        def create
          if options.delete(:balance) == true
            options[:amount] = Stripe::Balance.retrieve(api_key).available.first.amount
          else
            options[:amount] ||= ask('Amount in Dollars:')
            options[:amount] = (Float(options[:amount]) * 100).to_i
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