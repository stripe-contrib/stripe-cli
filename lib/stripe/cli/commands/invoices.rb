module Stripe
  module CLI
    module Commands
      class Invoices < Command

        desc "list", "List invoices (optionally by customer_id)"
        option :starting_after, :desc => "The ID of the last object in the previous paged result set. For cursor-based pagination."
        option :ending_before, :desc => "The ID of the first object in the previous paged result set, when paging backwards through the list."
        option :limit, :desc => "a limit on the number of resources returned, between 1 and 100"
        option :offset, :desc => "the starting index to be used, relative to the entire list"
        option :count, :desc => "depricated: use limit"
        option :customer, :desc => "a customer ID to filter results by"
        def list
          super Stripe::Invoice, options
        end

        desc "find ID", "Find an invoice"
        def find invoice_id
          super Stripe::Invoice, invoice_id
        end

        desc "close ID", "close an unpaid invoice"
        def close invoice_id
          request Stripe::Invoice.new(invoice_id, api_key), :close
        end

        desc "pay ID", "trigger an open invoice to be paid immediately"
        def pay invoice_id
          request Stripe::Invoice.new(invoice_id, api_key), :pay
        end

        desc "upcoming CUSTOMER", "find the upcoming invoice for CUSTOMER"
        def upcoming customer_id
          request Stripe::Invoice, :upcoming, {:customer => customer_id}, api_key
        end
      end
    end
  end
end