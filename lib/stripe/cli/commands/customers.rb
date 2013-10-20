module Stripe
  module CLI
    module Commands
      class Customers < Command
        include Stripe::Utils

        desc "list", "List customers"
        option :count
        option :offset

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