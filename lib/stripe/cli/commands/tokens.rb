module Stripe
  module CLI
    module Commands
      class Tokens < Command
        include Stripe::Utils

        desc "find ID", "Find a Token"
        def find event_id
          super Stripe::Event, event_id
        end

        desc "create TYPE", "create a new token of type TYPE(card or account)"
        option :card, :type => :hash, :default => {}, :desc => "hash of card params. may also be provided individually or added interactively."
        option :card_number, :aliases => "--number", :desc => "credit card number. usually 16 digits long"
        option :card_exp_month, :aliases => "--exp-month", :desc => "Two digit expiration month of card"
        option :card_exp_year, :aliases => "--exp-year", :desc => "Four digit expiration year of card"
        option :card_cvc, :aliases => "--cvc", :desc => "Three or four digit security code located on the back of card"
        option :card_name, :aliases => "--name", :desc => "Cardholder's full name as displayed on card"
        option :bank_account, :aliases => "--account", :type => :hash, :default => {}, :desc => "hash of account params. may also be provided individually or added interactively."
        option :country
        option :routing_number
        option :account_number
        def create type
          case type
          when 'card', 'credit_card', 'credit card'
            credit_card = credit_card( options )
            options = {}
            options[:card] = credit_card
          when 'account', 'bank_account', 'bank account'
            bank_account = bank_account( options )
            options = {}
            options[:bank_account] = bank_account
          end

          super Stripe::Token, options
        end

      end
    end
  end
end