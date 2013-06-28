module Stripe
  module CLI
    module Commands
      class Charges < Command
        desc "list", "List charges"
        option :count
        option :customer
        option :offset
        def list
          output Stripe::Charge.all(options, api_key)
        end

        desc "find ID", "Find a charge"
        def find(charge_id)
          output Stripe::Charge.retrieve(charge_id, api_key)
        end

        desc "refund ID", "Refund a charge"
        def refund(charge_id)
          output Stripe::Charge.new(charge_id, api_key).refund
        end

        desc "capture ID", "Capture a charge"
        def capture(charge_id)
          output Stripe::Charge.new(charge_id, api_key).capture
        end

        desc "create", "Create a charge"
        option :card
        option :card_number
        option :card_exp_month
        option :card_exp_year
        option :card_cvc
        option :card_name
        option :amount, :type => :numeric
        option :currency, :default => 'usd'
        option :description
        option :capture, :type => :boolean

        def create
          options[:amount] ||= ask('Amount in dollars:')
          options[:amount] = (Float(options[:amount]) * 100).to_i

          unless options[:card]
            options[:card_number]    ||= ask('Card number:')
            options[:card_exp_month] ||= ask('Card exp month:')
            options[:card_exp_year]  ||= ask('Card exp year:')
            options[:card_cvc]       ||= ask('Card CVC:')
            options[:card_name]      ||= ask('Card name:')

            options[:card] = {
              :number    => options[:card_number],
              :exp_month => options[:card_exp_month],
              :exp_year  => options[:card_exp_year],
              :cvc       => options[:card_cvc],
              :name      => options[:card_name]
            }

            options.delete(:card_number)
            options.delete(:card_exp_month)
            options.delete(:card_exp_year)
            options.delete(:card_cvc)
            options.delete(:card_name)
          end

          output Stripe::Charge.create(options, api_key)
        end
      end
    end
  end
end