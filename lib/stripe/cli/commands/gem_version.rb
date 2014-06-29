module Stripe
  module CLI
    module Commands
      class Version < Command
        desc "version", "display the current gem version number"
        def version
          puts "stripe-cli v#{Stripe::CLI::VERSION}"
        end

        default_command :version
      end
    end
  end
end