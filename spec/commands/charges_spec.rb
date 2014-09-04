require 'spec_helper'

describe Stripe::CLI::Commands::Charges do
  let(:_id_){ "a-charge-id" }


  describe "#refund" do

    # it "takes a charge_id and refunds the associated charge entirely" do
    #   request_hash = Stripe::CLI::Runner.start ["charges", "refund", _id_]
    #   request_hash[:url].should == "https://api.stripe.com/v1/charges/a-charge-id/refund"
    #   request_hash[:payload].should == ""
    # end
    #
    # it "takes a charge_id and an optional [--amount] and partially refunds the associated charge" do
    #   request_hash = Stripe::CLI::Runner.start ["charges", "refund", _id_, "--amount=100.99"]
    #   request_hash[:url].should == "https://api.stripe.com/v1/charges/a-charge-id/refund"
    #   request_hash[:payload].should == "amount=10099"
    # end

  end

end