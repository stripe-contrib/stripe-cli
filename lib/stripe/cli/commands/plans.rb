module Stripe
  module CLI
    module Commands
      class Plans < Command
        include Stripe::Utils

        desc "list", "List plans"
        option :starting_after, :desc => "The ID of the last object in the previous paged result set. For cursor-based pagination."
        option :ending_before, :desc => "The ID of the first object in the previous paged result set, when paging backwards through the list."
        option :limit, :desc => "a limit on the number of resources returned, between 1 and 100"
        option :offset, :desc => "the starting index to be used, relative to the entire list"
        option :count, :desc => "depricated: use limit"
        def list
          super Stripe::Plan, options
        end

        desc "find ID", "Find a plan"
        def find plan_id
          super Stripe::Plan, plan_id
        end

        desc "delete ID", "Delete a plan"
        def delete plan_id
          super Stripe::Plan, plan_id
        end

        desc "create", "Create a new plan"
        option :name, :desc => "Name displayed on invoices and in the Dashboard"
        option :id, :desc => "Unique name used to identify this plan when subscribing a customer"
        option :amount, :type => :numeric, :desc => "Amount in dollars"
        option :interval, :enum => %w( day week month year ), :default => "month", :desc => "Billing frequency"
        option :interval_count, :type => :numeric, :default => 1, :desc => "The number of intervals between each subscription billing."
        option :currency, :default => "usd"
        option :trial_period_days, :type => :numeric, :default => 0, :desc => "Number of days to delay a customer's initial bill"
        option :metadata, :type => :hash, :desc => "a key/value store of additional user-defined data"
        def create
          options[:amount]   = convert_amount(options[:amount])
          options[:name]   ||= ask('Plan name:')
          options[:id]     ||= ask('Plan id:')

          super Stripe::Plan, options
        end
      end
    end
  end
end