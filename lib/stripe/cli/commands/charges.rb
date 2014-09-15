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
        option :customer, :desc => "a customer ID to filter results by"
        def list
          super Stripe::Charge, options
        end

        desc "find ID", "Find a charge"
        def find charge_id
          super Stripe::Charge, charge_id
        end

        desc "refund ID", "Refund a charge"
        option :amount, :type => :numeric, :desc => "Refund amount in dollars. (Entire charge by default)"
        option :metadata, :type => :hash, :desc => "a key/value store of additional user-defined data"
        option :refund_application_fee, :type => :boolean, :default => false, :desc => "Whether or not to refund the application fee"
        def refund charge_id
          options[:amount] = convert_amount(options[:amount]) if options[:amount]
          if charge = retrieve_charge(charge_id)
            request charge.refunds, :create, options
          end
        end

        desc "capture ID", "Capture a charge"
        def capture charge_id
          request Stripe::Charge.new(charge_id, api_key), :capture
        end

        desc "create", "Create a charge"
        option :customer, :desc => "The ID of an existing customer to charge"
        option :card, :aliases => "--token", :desc => "credit card Token or ID. May also be created interactively."
        option :card_number, :aliases => "--number", :desc => "credit card number. usually 16 digits long"
        option :card_exp_month, :aliases => "--exp-month", :desc => "Two digit expiration month of card"
        option :card_exp_year, :aliases => "--exp-year", :desc => "Four digit expiration year of card"
        option :card_cvc, :aliases => "--cvc", :desc => "Three or four digit security code located on the back of card"
        option :card_name, :aliases => "--name", :desc => "Cardholder's full name as displayed on card"
        option :amount, :type => :numeric, :desc => "Charge amount in dollars"
        option :currency, :default => "usd", :desc => "3-letter ISO code for currency"
        option :description, :desc => "Arbitrary description of charge"
        option :capture, :type => :boolean, :default => true, :desc => "Whether or not to immediately capture the charge. Uncaptured charges expire in 7 days"
        option :metadata, :type => :hash, :desc => "A key/value store of additional user-defined data"
        option :statement_description, :desc => "Displayed alongside your company name on your customer's card statement (15 character max)"
        option :receipt_email, :desc => "Email address to send receipt to. Overrides default email settings."
        def create
          options[:amount] = convert_amount(options[:amount])

          options[:card] ||= credit_card( options ) unless options[:customer]

          super Stripe::Charge, options
        end

      end
    end
  end
end