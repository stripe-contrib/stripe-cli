module Stripe
  module CLI
    module Commands
      class Transfers < Command
        desc "list", "List transfers"
        option :count
        option :offset
        option :recipient
        option :status, :enum => %w( pending paid failed )

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