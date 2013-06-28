module Stripe
  module CLI
    class Command < Thor
      protected

      def api_key
        options[:key]
      end

      def inspect(object)
        case object
        when Array
          object.map {|o| inspect(o) }
        when Hash
          object.inject({}) do |hash, (key, value)|
            hash[key] = inspect(value)
            hash
          end
        when Stripe::ListObject
          inspect object.data
        when Stripe::StripeObject
          inspect object.to_hash
        else
          object
        end
      end

      def output(objects)
        ap(
          inspect(objects),
          :indent => -2
        )
      end
    end
  end
end