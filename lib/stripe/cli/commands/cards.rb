module Stripe
  module CLI
    module Commands
      class Cards < Command
        include Stripe::Utils

        desc "list", "List cards for OWNER (customer or recipient)"
        option :starting_after, :desc => "The ID of the last object in the previous paged result set. For cursor-based pagination."
        option :ending_before, :desc => "The ID of the first object in the previous paged result set, when paging backwards through the list."
        option :limit, :desc => "a limit on the number of resources returned, between 1 and 100"
        option :offset, :desc => "the starting index to be used, relative to the entire list"
        option :count, :desc => "depricated: use limit"
        option :owner, :required => true, :desc => "id of customer or recipient to search within"
        def list
          if owner = retrieve_owner(options.delete :owner)
            super owner.cards, options
          end
        end

        desc "find ID", "find ID card for OWNER (customer or recipient)"
        option :owner, :required => true, :desc => "id of customer or recipient to search within"
        def find card_id
          if owner = retrieve_owner(options.delete :owner)
            super owner.cards, card_id
          end
        end


        desc "create", "create a new card for OWNER (customer or recipient)"
        option :card, :aliases => :token, :desc => "credit card Token or ID. May also be created interactively."
        option :card_number, :aliases => :number
        option :card_exp_month, :aliases => :exp_month, :desc => "Two digit expiration month of card"
        option :card_exp_year, :aliases => :exp_year, :desc => "Four digit expiration year of card"
        option :card_cvc, :aliases => :cvc, :desc => "Three or four digit security code located on the back of card"
        option :card_name, :aliases => :name, :desc => "Cardholder's full name as displayed on card"
        option :owner, :required => true, :desc => "id of customer or recipient receiving new card"
        def create
          options[:card] ||= credit_card( options )
          if owner = retrieve_owner(options.delete :owner)
            super owner.cards, options
          end
        end

        desc "delete ID", "delete ID card for OWNER (customer or recipient)"
        option :owner, :required => true, :desc => "id of customer or recipient to search within"
        def delete card_id
          if owner = retrieve_owner(options.delete :owner) and
            card = retrieve_card(owner, card_id)
              request card, :delete
          end
        end

      end
    end
  end
end