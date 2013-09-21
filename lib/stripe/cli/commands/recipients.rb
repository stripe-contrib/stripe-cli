module Stripe
  module CLI
    module Commands
      class Recipients < Command
        desc "list", "List recipients"
        option :count
        option :offset
        option :verified => :boolean

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

        desc "create", "create a new recipient"
        option :name
        option :type, :enum => %w( individual corporation )
        option :individual, :type => :boolean, :aliases => :i
        option :corporation, :type => :boolean, :aliases => :c
        option :tax_id, :type => :numeric
        option :email
        option :description
        option :bank_account
        option :country
        option :account_number
        option :routing_number

        def create
          options[:name]   ||= ask('Recipient\'s Name:')
          options[:email]  ||= ask('Recipient\'s Email:')
          options[:type]   ||= if options.delete(:individual) then 'individual'
          elsif options.delete(:corporation) then 'corporation'
          else  ask('Corporation? (Yn)').downcase.start_with?("y") ? 'corporation' : 'individual'
          end
          options[:tax_id] ||= case options[:type]
          when 'individual' then ask('Tax ID (SSN):')
          when 'corporation' then ask('Tax ID (EIN):')
          end
          options[:tax_id].gsub!(/[^\d]/,"")

          unless options[:bank_account]
            options[:country] ||= 'US'
            options[:account_number] ||= ask('Bank Account Number:')
            options[:routing_number] ||= ask('Bank Routing Number:')

            options[:bank_account] = {
              :country        => options.delete(:country),
              :account_number => options.delete(:account_number),
              :routing_number => options.delete(:routing_number)
            }
          end

          super Stripe::Recipient, options
        end
      end
    end
  end
end