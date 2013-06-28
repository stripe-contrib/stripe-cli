module Stripe
  module CLI
    module Commands
      class Charges < Command
        desc "list", "List charges"
        option :key, :aliases => :k

        def list
          output Stripe::Charge.all({}, api_key)
        end

        desc "find ID", "Find a charge"
        option :key, :aliases => :k

        def find(charge_id)
          output Stripe::Charge.retrieve(charge_id, api_key)
        end

        desc "refund ID", "Refund a charge"
        option :key, :aliases => :k

        def refund(charge_id)
          output Stripe::Charge.new(charge_id, api_key).refund
        end

        desc "capture ID", "Capture a charge"
        option :key, :aliases => :k

        def capture(charge_id)
          output Stripe::Charge.new(charge_id, api_key).capture
        end
      end
    end
  end
end