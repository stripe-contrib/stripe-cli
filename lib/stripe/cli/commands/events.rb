module Stripe
  module CLI
    module Commands
      class Events < Command

        desc "list", "List events"
        option :starting_after, :desc => "The ID of the last object in the previous paged result set. For cursor-based pagination."
        option :ending_before, :desc => "The ID of the first object in the previous paged result set, when paging backwards through the list."
        option :limit, :desc => "a limit on the number of resources returned, between 1 and 100"
        option :offset, :desc => "the starting index to be used, relative to the entire list"
        option :count, :desc => "depricated: use limit"
        option :object_id, :desc => "only list events pertaining to the object with this ID"
        option :type, :desc => "only list events of type TYPE"
        def list
          super Stripe::Event, options
        end

        desc "find ID", "Find a event"
        def find event_id
          super Stripe::Event, event_id
        end
      end
    end
  end
end