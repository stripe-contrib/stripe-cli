module Stripe
  module CLI
    module Commands
      class Coupons < Command
        desc "list", "List coupons"
        option :count
        option :offset

        def list
          super Stripe::Coupon, options
        end

        desc "find ID", "Find a coupon`"
        def find coupon_id
          super Stripe::Coupon, coupon_id
        end

				desc "delete ID", "Delete a coupon"
				def delete coupon_id
					super Stripe::Coupon, coupon_id
				end

				desc "create", "Create a new Coupon"
				option :id
				option :percent_off, :type => :numeric
				option :amount_off, :type => :numeric
				option :duration, :enum => [ :forever, :once, :repeating ]
				option :redeem_by
				option :max_redemptions, :type => :numeric
				option :duration_in_months
				option :currency, :default => 'usd'

				def create
					options[:id] ||= ask('Coupon ID:')
					options[:percent_off] ||= ask('Percentage off:') unless options[:amount_off]
					options[:amount_off]  ||= ask('dollar amount off:') unless options[:percent_off]
					options[:duration]    ||= ask('(`forever`,`once`, or `repeating`) duration:')
					options[:duration_in_months] ||= ask('for how many months?') if options[:duration] == "repeating"
					options[:redeem_by]   ||= ask('expire date:')

					super Stripe::Coupon, options
				end
      end
    end
  end
end