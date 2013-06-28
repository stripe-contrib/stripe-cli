module Stripe
  module CLI
    module Commands
      class Charges < Command
        desc "list", "List charges"
        option :count
        option :customer
        option :offset

        def list
          output Stripe::Charge.all(options, api_key)
        end

        desc "find ID", "Find a charge"
        def find(charge_id)
          output Stripe::Charge.retrieve(charge_id, api_key)
        end

        desc "refund ID", "Refund a charge"
        def refund(charge_id)
          output Stripe::Charge.new(charge_id, api_key).refund
        end

        desc "capture ID", "Capture a charge"
        def capture(charge_id)
          output Stripe::Charge.new(charge_id, api_key).capture
        end
      end
    end
  end
end