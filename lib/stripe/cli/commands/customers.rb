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
        option :description
        option :email
        option :plan
        option :coupon
        option :quantity
        option :trial_end
        option :account_balance
        option :card
        option :card_number
        option :card_exp_month
        option :card_exp_year
        option :card_cvc
        option :card_name
        option :metadata, :type => :hash
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

          options[:card] ||= credit_card( options ) if options[:plan]

          super Stripe::Customer, options
        end
      end
    end
  end
end