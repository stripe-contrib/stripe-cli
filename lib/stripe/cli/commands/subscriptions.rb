require 'chronic'
module Stripe
  module CLI
    module Commands
      class Subscriptions < Command
        include Stripe::Utils

        desc "list", "List subscriptions for CUSTOMER customer"
        option :starting_after, :desc => "The ID of the last object in the previous paged result set. For cursor-based pagination."
        option :ending_before, :desc => "The ID of the first object in the previous paged result set, when paging backwards through the list."
        option :limit, :desc => "a limit on the number of resources returned, between 1 and 100"
        option :offset, :desc => "the starting index to be used, relative to the entire list"
        option :count, :desc => "depricated: use limit"
        option :customer, :aliases => :c, :required => true, :desc => "ID of customer to search within"
        def list
          if cust = retrieve_customer(options.delete :customer)
            super cust.subscriptions, options
          end
        end

        desc "find ID", "find ID subscription for CUSTOMER customer"
        option :customer, :aliases => :c, :required => true, :desc => "ID of customer to search within"
        def find subscription_id
          if cust = retrieve_customer(options.delete :customer)
            super cust.subscriptions, subscription_id
          end
        end

        desc "create", "create a subscription for CUSTOMER customer"
        option :plan, :desc => "the plan to assign to CUSTOMER customer"
        option :coupon, :desc => "id of a coupon to apply"
        option :trial_end, :desc => "apply a trial period until this date. Override plan's trial period."
        option :card, :aliases => :token, :desc => "credit card Token or ID. May also be created interactively."
        option :card_number, :aliases => :number
        option :card_exp_month, :aliases => :exp_month, :desc => "Two digit expiration month of card"
        option :card_exp_year, :aliases => :exp_year, :desc => "Four digit expiration year of card"
        option :card_cvc, :aliases => :cvc, :desc => "Three or four digit security code located on the back of card"
        option :card_name, :aliases => :name, :desc => "Cardholder's full name as displayed on card"
        option :metadata, :type => :hash, :desc => "a key/value store of additional user-defined data"
        option :customer, :aliases => :c, :required => true, :desc => "ID of customer receiving the new subscription"
        def create
          options[:plan]      ||= ask('Assign a plan:')
          options.delete( :plan ) if options[:plan] == ""
          options[:coupon]    ||= ask('Apply a coupon:')
          options.delete( :coupon ) if options[:coupon] == ""
          options[:card]      ||= credit_card( options ) if yes?("add a new credit card? [yN]",:yellow)
          options[:trial_end] = Chronic.parse(options[:trial_end]).to_i.to_s if options[:trial_end]
          if cust = retrieve_customer(options.delete :customer)
            super cust.subscriptions, options
          end
        end


        desc "cancel ID", "cancel ID subscription for CUSTOMER customer"
        option :at_period_end, :type => :boolean, :default =>  false, :desc => "delay cancellation until end of current period"
        option :customer, :aliases => :c, :required => true, :desc => "id of customer to search within"
        def cancel subscription_id
          options[:at_period_end] ||= yes?("delay until end of current period? [yN]",:yellow)
          if cust = retrieve_customer(options.delete :customer) and
            subscription = retrieve_subscription(cust, subscription_id)
              request subscription, :delete, options
          end
        end

        desc "reactivate ID", "reactivate auto-renewal if `cancel-at-period-end` was set to true"
        option :customer, :aliases => :c, :required => true, :desc => "id of customer to search within"
        def reactivate subscription_id
          if cust = retrieve_customer(options.delete :customer) and
            subscription = retrieve_subscription(cust, subscription_id)
              request subscription, :save
          end
        end

      end
    end
  end
end
