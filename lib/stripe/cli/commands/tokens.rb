module Stripe
  module CLI
    module Commands
      class Tokens < Command
        include Stripe::Utils

        desc "find ID", "Find a Token"
        def find event_id
          super Stripe::Token, event_id
        end

        desc "create TYPE", "create a new token of type TYPE(card or account)"
        option :card, :type => :hash, :default => {}, :desc => "hash of card params. may also be provided individually or added interactively."
        option :card_number, :aliases => "--number", :desc => "credit card number. usually 16 digits long"
        option :card_exp_month, :aliases => "--exp-month", :desc => "Two digit expiration month of card"
        option :card_exp_year, :aliases => "--exp-year", :desc => "Four digit expiration year of card"
        option :card_cvc, :aliases => "--cvc", :desc => "Three or four digit security code located on the back of card"
        option :card_name, :aliases => "--name", :desc => "Cardholder's full name as displayed on card"
        option :bank_account, :aliases => "--account", :type => :hash, :default => {}, :desc => "hash of account params. may also be provided individually or added interactively."
        option :country, :desc => "country of bank account. currently supports 'US' only"
        option :routing_number, :desc => "ACH routing number for bank account"
        option :account_number, :desc => "account number of bank account. Must be a checking account"
        def create type
          opt_symbol, value_hash = case type
          when 'card', 'credit_card', 'credit card'
            [ :card, credit_card( options ) ]
          when 'account', 'bank_account', 'bank account'
            [ :bank_account, bank_account( options ) ]
          end

          options.delete_if {|option,_| strip_list.include? option }

          options[opt_symbol] = value_hash

          super Stripe::Token, options
        end

        private

        def strip_list
          %i( card card_number card_exp_month card_exp_year card_cvc card_name bank_account country routing_number account_number )
        end

      end
    end
  end
end