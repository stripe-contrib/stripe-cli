module Stripe
  module CLI
    module Commands
      class Customers < Command
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

				def create
					options[:email]  ||= ask('Customer\'s Email:')
					options[:description] ||= ask('(Optional) Provide a description:')
					options[:plan]   ||= ask('(Optional) Assign customer a plan:')
					options[:coupon] ||= ask('(Optional) Apply a coupon:')

          if options[:plan]
            options[:card_name]      ||= ask('Name on Card:')
            options[:card_number]    ||= ask('Card number:')
            options[:card_cvc]       ||= ask('CVC code:')
            options[:card_exp_month] ||= ask('expiration month:')
            options[:card_exp_year]  ||= ask('expiration year:')

            options[:card] = {
              :number    => options.delete(:card_number),
              :exp_month => options.delete(:card_exp_month),
              :exp_year  => options.delete(:card_exp_year),
              :cvc       => options.delete(:card_cvc),
              :name      => options.delete(:card_name)
            }
          end unless options[:card]

					super Stripe::Customer, options
				end
      end
    end
  end
end