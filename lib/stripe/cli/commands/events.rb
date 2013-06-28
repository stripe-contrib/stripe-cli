module Stripe
  module CLI
    module Commands
      class Events < Command
        desc "list", "List events"
        option :count
        option :offset

        def list
          output Stripe::Event.all(options, api_key)
        end

        desc "find ID", "Find a event`"
        def find(event_id)
          output Stripe::Event.retrieve(event_id, api_key)
        end
      end
    end
  end
end