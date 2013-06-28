module Stripe
  module CLI
    module Commands
      class Customers < Command
        desc "list", "List customers"
        option :count
        option :offset

        def list
          output Stripe::Customer.all(options, api_key)
        end

        desc "find ID", "Find a customer"
        def find(customer_id)
          output Stripe::Customer.retrieve(customer_id, api_key)
        end

        desc "delete ID", "Delete a customer"
        def delete(customer_id)
          output Stripe::Customer.new(customer_id, api_key).delete
        end
      end
    end
  end
end