module Stripe
  module CLI
    module Commands
      class Charges < Command
        desc "list", "List charges"
        option :count
        option :customer
        option :offset
        def list
          super Stripe::Charge, options
        end

        desc "find ID", "Find a charge"
        def find charge_id
        	super Stripe::Charge, charge_id
        end

        desc "refund ID", "Refund a charge"
        option :amount, :type => :numeric
        def refund charge_id
          options[:amount] = (Float(options[:amount]) * 100).to_i
          request Stripe::Charge.new(charge_id, api_key), :refund, options
        end

        desc "capture ID", "Capture a charge"
        def capture charge_id
          request Stripe::Charge.new(charge_id, api_key), :capture
        end

        desc "create", "Create a charge"
        option :customer
        option :card
        option :card_number
        option :card_exp_month
        option :card_exp_year
        option :card_cvc
        option :card_name
        option :amount, :type => :numeric
        option :currency, :default => 'usd'
        option :description
        option :capture, :type => :boolean, :default => true

        def create
          options[:amount] ||= ask('Amount in dollars:')
          options[:amount] = (Float(options[:amount]) * 100).to_i

          unless options[:card] || options[:customer]
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
          end

          super Stripe::Charge, options
        end
      end
    end
  end
end