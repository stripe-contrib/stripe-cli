module Stripe
  module Utils

    def credit_card options = {}
      {
        :name      => options.delete(:card_name)      || ask('Name on Card:'),
        :number    => options.delete(:card_number)    || ask('Card number:'),
        :cvc       => options.delete(:card_cvc)       || ask('CVC code:'),
        :exp_month => options.delete(:card_exp_month) || ask('expiration month:'),
        :exp_year  => options.delete(:card_exp_year)  || ask('expiration year:')
      }
    end

  end
end