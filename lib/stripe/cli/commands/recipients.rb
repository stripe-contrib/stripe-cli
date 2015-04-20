module Stripe
  module CLI
    module Commands
      class Recipients < Command
        include Stripe::Utils

        desc "list", "List recipients"
        option :starting_after, :desc => "The ID of the last object in the previous paged result set. For cursor-based pagination."
        option :ending_before, :desc => "The ID of the first object in the previous paged result set, when paging backwards through the list."
        option :limit, :desc => "a limit on the number of resources returned, between 1 and 100"
        option :offset, :desc => "the starting index to be used, relative to the entire list"
        option :count, :desc => "deprecated: use limit"
        option :verified, :type => :boolean, :desc => "Only return recipients that are verified or unverified"
        def list
          super Stripe::Recipient, options
        end

        desc "find ID", "Find a recipient"
        def find recipient_id
          super Stripe::Recipient, recipient_id
        end

        desc "delete ID", "delete a recipient"
        def delete recipient_id
          super Stripe::Recipient, recipient_id
        end

        desc "create", "create a new recipient. Either an Individual or a Corporation."
        option :name, :desc => "Full legal name of Individual or Corporation"
        option :type, :enum => %w( individual corporation ), :desc => "recipient type,"
        option :individual, :type => :boolean, :aliases => :i, :desc => "flag specifying recipient should be of type Individual"
        option :corporation, :type => :boolean, :aliases => :c, :desc => "flag specifying recipient should be of type Corporation"
        option :tax_id, :type => :numeric, :desc => "Full SSN for individuals or full EIN for corporations"
        option :email, :desc => "Recipient's email address"
        option :description, :desc => "Arbitrary description of recipient"
        option :bank_account, :aliases => "--account", :desc => "dictionary of bank account attributes as 'key':'value' pairs"
        option :country, :desc => "country of bank account. currently supports 'US' only"
        option :account_number, :desc => "account number of bank account. Must be a checking account"
        option :routing_number, :desc => "ACH routing number for bank account"
        option :card, :aliases => "--token", :desc => "credit card Token or ID. May also be created interactively."
        option :card_number, :aliases => "--number", :desc => "credit card number. usually 16 digits long"
        option :card_exp_month, :aliases => "--exp-month", :desc => "Two digit expiration month of card"
        option :card_exp_year, :aliases => "--exp-year", :desc => "Four digit expiration year of card"
        option :card_cvc, :aliases => "--cvc", :desc => "Three or four digit security code located on the back of card"
        option :card_name, :desc => "Cardholder's full name as displayed on card"
        option :metadata, :type => :hash, :desc => "a key/value store of additional user-defined data"
        def create
          options[:type] ||= recipient_type(options)

          case options[:type]
          when 'individual'
            options[:name]    ||= ask('Recipient\'s full, legal name:')
            options[:tax_id]  ||= ask('Tax ID (SSN):')
          when 'corporation'
            options[:name]    ||= ask('Full Incorporated Name:')
            options[:tax_id]  ||= ask('Tax ID (EIN):')
          end unless options[:name] && options[:tax_id]

          options[:tax_id].gsub!(/[^\d]/,"")

          options[:email]  ||= ask('Email Address:')

          unless options[:card] || no?('add a Debit Card? [yN]',:yellow)
            options[:card_name] ||= options[:name] if yes?('Name on card same as recipient name? [yN]')
            options[:card] = credit_card( options )
          end

          unless options[:bank_account] || no?('add a Bank Account? [yN]',:yellow)
            options[:bank_account] = bank_account( options )
          end

          options.delete :country
          options.delete :account_number
          options.delete :routing_number
          options.delete :card_number
          options.delete :card_exp_month
          options.delete :card_exp_year
          options.delete :card_cvc
          options.delete :card_name

          super Stripe::Recipient, options
        end

        private

        def recipient_type opt
          opt.delete(:individual) ? 'individual' :
          opt.delete(:corporation) ? 'corporation' :
          yes?('Corporation? [yN]') ? 'corporation' : 'individual'
        end
      end
    end
  end
end