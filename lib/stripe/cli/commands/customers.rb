require 'chronic'
module Stripe
  module CLI
    module Commands
      class Customers < Command
        include Stripe::Utils

        desc "list", "List customers"
        option :starting_after, :desc => "The ID of the last object in the previous paged result set. For cursor-based pagination."
        option :ending_before, :desc => "The ID of the first object in the previous paged result set, when paging backwards through the list."
        option :limit, :desc => "a limit on the number of resources returned, between 1 and 100"
        option :offset, :desc => "the starting index to be used, relative to the entire list"
        option :count, :desc => "depricated: use limit"
        def list
          super Stripe::Customer, options
        end

        desc "find ID", "Find a customer"
        def find customer_id
          super Stripe::Customer, customer_id
        end

        desc "delete ID", "Delete a customer"
        def delete customer_id
          super Stripe::Customer, customer_id
        end

        desc "create", "Create a new customer"
        option :description, :desc => "Arbitrary description to be displayed in Stripe Dashboard."
        option :email, :desc => "Customer's email address. Will be displayed in Stripe Dashboard."
        option :plan, :desc => "The ID of a Plan this customer should be subscribed to. Requires a credit card."
        option :coupon, :desc => "The ID of a Coupon to be applied to all of Customer's recurring charges"
        option :quantity, :desc => "A multiplier for the plan option. defaults to `1'"
        option :trial_end, :desc => "apply a trial period until this date. Override plan's trial period."
        option :account_balance, :desc => "customer's starting account balance in cents. A positive amount will be added to the next invoice while a negitive amount will act as a credit."
        option :card, :aliases => "--token", :desc => "credit card Token or ID. May also be created interactively."
        option :card_number, :aliases => "--number"
        option :card_exp_month, :aliases => "--exp-month", :desc => "Two digit expiration month of card"
        option :card_exp_year, :aliases => "--exp-year", :desc => "Four digit expiration year of card"
        option :card_cvc, :aliases => "--cvc", :desc => "Three or four digit security code located on the back of card"
        option :card_name, :aliases => "--name", :desc => "Cardholder's full name as displayed on card"
        option :metadata, :type => :hash, :desc => "a key/value store of additional user-defined data"
        def create
          options[:email]       ||= ask('Customer\'s Email:')
          options[:description] ||= ask('Provide a description:')
          options[:plan]        ||= ask('Assign a plan:')
          if options[:plan] == ""
            options.delete :plan
          else
            options[:coupon]    ||= ask('Apply a coupon:')
          end
          options.delete( :coupon ) if options[:coupon] == ""

          if options[:plan]
            options[:card] ||= credit_card( options )
            options[:trial_end] = Chronic.parse(options[:trial_end]).to_i.to_s if options[:trial_end]
          end

          super Stripe::Customer, options
        end
      end
    end
  end
end