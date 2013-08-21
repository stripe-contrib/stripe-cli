require 'rspec'
require_relative '../lib/stripe/cli.rb'

describe Stripe::CLI::Command do
	let(:_id_) { "random-id-string" }
	before :all do
		Stripe::CLI::Command.class_eval do
			protected
			def api_key
				"stripe-key"
			end
		end
	end
	describe "#find" do

		it "calls super, passing in `Stripe::Charge` and an `id`" do
			Stripe::Charge.should_receive(:retrieve).with( _id_, "stripe-key" )

			Stripe::CLI::Runner.start ["charges", "find", _id_]
		end

		it "calls super, passing in `Stripe::Plan` and an `id`" do
			Stripe::Plan.should_receive(:retrieve).with( _id_, "stripe-key" )

			Stripe::CLI::Runner.start ["plans", "find", _id_]
		end

	end

	describe "method missing" do
		let(:double) { double( Class.new ) }
		it "can create arbitrary methods durring runtime" do
			# Stripe::Charge.should_receive( :new ).with( _id_, "stripe-key" ).and_return( double )
			# double.should_receive( :capture )
			# Stripe::Charge.any_instance.should_receive(:capture)
			Stripe::CLI::Command.should_receive( :capture ).with( Stripe::Charge, _id_ )

			Stripe::CLI::Runner.start ["charges", "capture", _id_]

		end
	end

end