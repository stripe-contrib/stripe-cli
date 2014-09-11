module Stripe
  module Utils

    private

    def credit_card options = {}
      card = options.delete(:card) || {}
      {
        :name      => card["name"]      || options.delete(:card_name)      || ask('Name on Card:'),
        :number    => card["number"]    || options.delete(:card_number)    || ask('Card Number:'),
        :cvc       => card["cvc"]       || options.delete(:card_cvc)       || ask('CVC code:'),
        :exp_month => card["exp-month"] || options.delete(:card_exp_month) || ask('Expiration Month:'),
        :exp_year  => card["exp-year"]  || options.delete(:card_exp_year)  || ask('Expiration Year:')
      }
    end

    def bank_account options = {}
      account = options.delete(:bank_account) || {}
      {
        :account_number => account["account-number"] || options.delete(:account_number) || ask('Account Number:'),
        :routing_number => account["routing-number"] || options.delete(:routing_number) || ask('Routing Number:'),
        :country => account["country"] || options.delete(:country) || 'US'
      }
    end

    def retrieve_customer id
      begin
        ::Stripe::Customer.retrieve(id, api_key)
      rescue Exception => e
        ap e.message
        false
      end
    end

    def retrieve_charge id
      begin
        ::Stripe::Charge.retrieve(id, api_key)
      rescue Exception => e
        ap e.message
        false
      end
    end

    def retrieve_recipient id
      begin
        ::Stripe::Recipient.retrieve(id, api_key)
      rescue Exception => e
        ap e.message
        false
      end
    end

    def retrieve_subscription cust, id
      begin
        cust.subscriptions.retrieve(id)
      rescue Exception => e
        ap e.message
        false
      end
    end

    def retrieve_card owner, id
      begin
        owner.cards.retrieve(id)
      rescue Exception => e
        ap e.message
        false
      end
    end

    def retrieve_owner id
      if id.start_with? "r"
        retrieve_recipient(id)
      else
        retrieve_customer(id)
      end
    end

  end
end