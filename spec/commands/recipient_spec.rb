require 'spec_helper'

describe Stripe::CLI::Commands::Recipients do

  describe "#create" do

    it "can determine recipient type from the passed options" do
      Stripe.should_receive(:execute_request).with do |opts|
        opts[:headers][:authorization] == 'Bearer stripe-key'
      end
      request_hash = Stripe::CLI::Runner.start ["recipients", "create", "--corporation", "--name=John Doe"]
      expect(request_hash[:url]).to eq("https://api.stripe.com/v1/recipients")
      expect(request_hash[:payload]).to eq("type=individual&name=John Doe")
    end


  end

end