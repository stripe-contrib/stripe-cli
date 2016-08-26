require 'parseconfig'

module Stripe
  module CLI
    class Command < Thor
      @@root_config = ::File.expand_path('~/.stripecli')
      @@local_config = ::File.expand_path('./.stripecli')

      class_option :key, :aliases => :k, :type => :string, :desc => "One of your API secret keys, provided by Stripe"
      class_option :env, :aliases => :e, :type => :string, :desc => "This param expects a ~/.stripecli file with section headers for any string passed into it"
      class_option :version, :aliases => :v, :type => :string, :desc => "Stripe API version-date. Looks like `YYYY-MM-DD`"
      class_option :dates, :aliases => :d, :type => :string, :desc => "Date Style. It should be either local, utc, or unix. Defaults to local.", :enum => %w(local utc unix)
      class_option :dollar_amounts, :type => :boolean, :desc => "set expected currency units to dollars or cents"
      class_option :strip_nils, :type => :boolean, :desc => "use this flag to strip nil valued attributes from the output"
      class_option :expand, :type => :array, :desc => "one or more ID properties of the response you'd like expanded into full objects"


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

      def date_format
        options.delete(:dates) || stored_api_option('dates')
      end

      def dollar_amounts
        options.delete(:dollar_amounts) { !(stored_api_option('dollar_amounts') == 'false') }
      end

      def strip_nils?
        options.delete(:strip_nils) { stored_api_option('strip_nils') == "true" }
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
        request klass, :all, options
      end

      def find klass, id
        request klass, :retrieve, {:id => id, :expand => options[:expand]}
      end

      def delete klass, id
        request klass.new( id, {:api_key => api_key} ), :delete
      end

      def create klass, options
        request klass, :create, options
      end

      def request object, method, *arguments
        pre_request_setup
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
          object > 1000000000 ? handle_date(object) : object
        else
          object
        end
      end
      public :inspect

    private

      def output objects
        ap inspect( objects ), :indent => -2
      end

      # strip non-api params from options hash
      # set api_version & api_key
      def pre_request_setup
        @strip_nils = strip_nils?
        @date_format = date_format
        Stripe.api_key = api_key
        Stripe.api_version = api_version unless api_version.nil?
      end

      def handle_hash object
        object.inject({}) do |hash, (key, value)|
          hash[key] = inspect( value ) unless @strip_nils && value.nil?
          hash
        end
      end

      def handle_date object
        case @date_format
        when 'unix' then
          object
        when 'utc'
          Time.at( object ).utc
        else
          Time.at( object )
        end
      end
    end
  end
end