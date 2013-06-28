module Stripe
  module CLI
    module Commands
      class Plans < Command
        desc "list", "List plans"
        option :count
        option :offset

        def list
          output Stripe::Plan.all(options, api_key)
        end

        desc "find ID", "Find a plan"
        def find(plan_id)
          output Stripe::Plan.retrieve(plan_id, api_key)
        end

        desc "delete ID", "Delete a plan"
        def delete(plan_id)
          output Stripe::Plan.new(plan_id, api_key).delete
        end
      end
    end
  end
end