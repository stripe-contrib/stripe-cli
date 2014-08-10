module Stripe
  module CLI
    module Commands
      class Charges < Command
        include Stripe::Utils

        desc "list", "List charges (optionally by customer_id)"
        option :starting_after, :desc => "The ID of the last object in the previous paged result set. For cursor-based pagination."
        option :ending_before, :desc => "The ID of the first object in the previous paged result set, when paging backwards through the list."
        option :limit, :desc => "a limit on the number of resources returned, between 1 and 100"
        option :offset, :desc => "the starting index to be used, relative to the entire list"
        option :count, :desc => "depricated: use limit"
        option :customer
        def list
          super Stripe::Charge, options
        end

        desc "find ID", "Find a charge"
        def find charge_id
        	super Stripe::Charge, charge_id
        end

        desc "refund ID", "Refund a charge"
        option :amount, :type => :numeric, :desc => "Refund amount in dollars"
        option :metadata, :type => :hash
        option :refund_application_fee, :type => :boolean, :default => false, :desc => "Whether or not to refund the application fee"
        def refund charge_id
          options[:amount] = (Float(options[:amount]) * 100).to_i if options[:amount]
          if charge = retrieve_charge(charge_id)
            request charge.refunds, :create, options
          end
        end

        desc "capture ID", "Capture a charge"
        def capture charge_id
          request Stripe::Charge.new(charge_id, api_key), :capture
        end

        desc "create", "Create a charge"
        option :customer, :desc => "The ID of an existing customer"
        option :card
        option :card_number
        option :card_exp_month
        option :card_exp_year
        option :card_cvc
        option :card_name
        option :amount, :type => :numeric, :desc => "Charge amount in dollars"
        option :currency, :default => 'usd'
        option :description
        option :capture, :type => :boolean, :default => true
        option :metadata, :type => :hash
        option :statement_description, :desc => "Displayed alongside your company name on your customer's card statement (15 character max)"
        option :receipt_email, :desc => "Email address to send receipt to. Overrides default email settings."
        def create
          options[:amount] ||= ask('Amount in dollars:')
          options[:amount] = (Float(options[:amount]) * 100).to_i

          options[:card] ||= credit_card( options ) unless options[:customer]

          super Stripe::Charge, options
        end

        private

        def retrieve_charge id
          begin
            Stripe::Charge.retrieve(id, api_key)
          rescue Exception => e
            ap e.message
            false
          end
        end

      end
    end
  end
end