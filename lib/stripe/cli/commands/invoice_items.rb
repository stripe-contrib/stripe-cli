module Stripe
  module CLI
    module Commands
      class InvoiceItems < Command
        include Stripe::Utils

        desc "list", "List invoice items (optionally by customer_id)"
        option :starting_after, :desc => "The ID of the last object in the previous paged result set. For cursor-based pagination."
        option :ending_before, :desc => "The ID of the first object in the previous paged result set, when paging backwards through the list."
        option :limit, :desc => "a limit on the number of resources returned, between 1 and 100"
        option :offset, :desc => "the starting index to be used, relative to the entire list"
        option :count, :desc => "deprecated: use limit"
        option :customer, :desc => "ID of customer who's invoice items we want to list"
        def list
          super Stripe::InvoiceItem, options
        end

        desc "find ID", "Find an invoice item"
        def find invoice_item_id
          super Stripe::InvoiceItem, invoice_item_id
        end

        desc "create", "Create a new invoice item for customer"
        option :customer, :desc => "The ID of customer for the invoice item"
        option :amount, :type => :numeric, :desc => "Amount in dollars (or cents when --no-dollar-amounts)"
        option :currency, :default => "usd", :desc => "3-letter ISO code for currency"
        option :description, :desc => "Arbitrary description of charge"
        option :invoice, :desc => "The ID of an existing invoice to add this invoice item to"
        option :subscription, :desc => "The ID of a subscription to add this invoice item to"
        option :discountable, :type => :boolean, :desc => "Controls whether discounts apply to this invoice item"
        option :metadata, :type => :hash, :desc => "A key/value store of additional user-defined data"
        def create
          options[:customer] ||= ask('Customer ID:')
          options[:amount] = convert_amount(options[:amount])
          super Stripe::InvoiceItem, options
        end

        desc "delete ID", "Delete a invoice item"
        def delete invoice_item_id
          super Stripe::InvoiceItem, invoice_item_id
        end
      end
    end
  end
end