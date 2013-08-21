module Stripe
  module CLI
    module Commands
      class Events < Command
        desc "list", "List events"
        option :count
        option :offset

        def list
          super Stripe::Event, options
        end

        desc "find ID", "Find a event`"
        def find event_id
          super Stripe::Event, event_id
        end
      end
    end
  end
end