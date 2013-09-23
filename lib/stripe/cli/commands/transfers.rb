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
        def create
          options[:amount] ||= ask('Amount in Dollars:')
          options[:amount] = (Float(options[:amount]) * 100).to_i
          options[:recipient] ||= ask('Recipient ID or self:')
          if options[:recipient] == ""
            return system( "stripe recipients create" ) if ask("Transfers require a `recipient_id`\nCreate a Recipient? (Y/n)").downcase.start_with? "y"
          else
            super Stripe::Transfer, options
          end
        end
      end
    end
  end
end