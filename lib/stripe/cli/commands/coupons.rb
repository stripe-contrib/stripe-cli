require 'chronic'
module Stripe
  module CLI
    module Commands
      class Coupons < Command

        desc "list", "List coupons"
        option :starting_after, :desc => "The ID of the last object in the previous paged result set. For cursor-based pagination."
        option :ending_before, :desc => "The ID of the first object in the previous paged result set, when paging backwards through the list."
        option :limit, :desc => "a limit on the number of resources returned, between 1 and 100"
        option :offset, :desc => "the starting index to be used, relative to the entire list"
        option :count, :desc => "depricated: use limit"
        def list
          super Stripe::Coupon, options
        end

        desc "find ID", "Find a coupon"
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
        option :duration, :enum => %w( forever once repeating )
        option :redeem_by, :desc => "coupon will no longer be accepted after this date."
        option :max_redemptions, :type => :numeric
        option :duration_in_months
        option :currency, :default => 'usd'
        option :metadata, :type => :hash, :desc => "a key/value store of additional user-defined data"
        def create
          unless options[:percent_off] || options[:amount_off]
            discount = ask('(e.g. 25% or $10) specify discount:')
            if discount.end_with?( '%' )
              options[:percent_off] = discount.gsub(/[^\d]/,"").to_i
            else
              options[:amount_off]  = discount.gsub(/[^\d]/,"").to_i
            end
          end
          options[:id] ||= ask('Coupon ID:')
          options[:duration]    ||= ask('(`forever`,`once`, or `repeating`) duration:')
          options[:duration_in_months] ||= ask('for how many months?') if options[:duration] == "repeating"
          options[:redeem_by]   ||= ask('expire on:')
          if options[:redeem_by].empty?
            options.delete(:redeem_by)
          else
            options[:redeem_by] = Chronic.parse(options[:redeem_by]).to_i.to_s
          end
          super Stripe::Coupon, options
        end
      end
    end
  end
end
