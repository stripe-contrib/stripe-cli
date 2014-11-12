require 'parseconfig'

module Stripe
  module CLI
    class Command < Thor
      @@root_config = ::File.expand_path('~/.stripecli')
      @@local_config = ::File.expand_path('./.stripecli')

      class_option :key, :aliases => :k, :desc => "One of your API secret keys, provided by Stripe"
      class_option :env, :aliases => :e, :desc => "This param expects a ~/.stripecli file with section headers for any string passed into it"
      class_option :version, :aliases => :v, :desc => "Stripe API version-date. Looks like `YYYY-MM-DD`"
      class_option :dollar_amounts, :type => :boolean, :desc => "set expected currency units to dollars or cents"

      protected

      def api_key
        @api_key ||= options[:key] || stored_api_option('key')
      end

      def api_version
        @api_version ||= options.delete(:version) || stored_api_option('version')
      end

      def environment
        @env ||= options.delete(:env) || config['default']
      end

      def dollar_amounts
        param_option = options.delete(:dollar_amounts)
        param_option.nil? ? stored_api_option('dollar_amounts') == 'false' ? false : true : param_option
      end

      def stored_api_option option
        if File.exists?(config_file)
          if environment
            config[environment][option.to_s] || config[option.to_s]
          else
            config[option.to_s]
          end
        end
      end

      def config
        ParseConfig.new(config_file) if File.exist?(config_file)
      end

      def config_file
        File.exist?(@@local_config) ? @@local_config : @@root_config
      end

      def list klass, options
        request klass, :all, options, api_key
      end

      def find klass, id
        request klass, :retrieve, id, api_key
      end

      def delete klass, id
        request klass.new( id, api_key ), :delete
      end

      def create klass, options
        request klass, :create, options, api_key
      end

      def request object, method, *arguments
        Stripe.api_version = api_version unless api_version.nil?
        begin
          output object.send method, *arguments
        rescue StripeError => e
          output e.message
        end
      end

      def inspect object
        case object
        when Array
          object.map {|o| inspect(o) }
        when Hash
          handle_hash object
        when Stripe::ListObject
          inspect object.data
        when Stripe::StripeObject
          inspect object.instance_variable_get(:@values)
        when Numeric
          object > 1000000000 ? Time.at( object ) : object
        else
          object
        end
      end
      public :inspect

    private

      def output objects
        ap inspect( objects ), :indent => -2
      end

      def handle_hash object
        object.inject({}) do |hash, (key, value)|
          hash[key] = inspect( value )
          hash
        end
      end
    end
  end
end