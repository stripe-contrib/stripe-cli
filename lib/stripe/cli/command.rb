require 'parseconfig'

module Stripe
  module CLI
    class Command < Thor
      class_option :key, :aliases => :k
      class_option :mode, :aliases => :m
      protected

      def api_key
        @api_key ||= options[:key] || stored_api_key
      end

      def stored_api_key
        if File.exists?(config_file)
          config = ParseConfig.new(config_file)
          groups = config.get_groups
          if groups.empty?
            config['key']
          else
            config[ options.delete(:mode)||groups[0] ]['key']
          end
        end
      end

      def config_file
        File.expand_path('~/.stripecli')
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
