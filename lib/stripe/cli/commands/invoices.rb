module Stripe
  module CLI
    module Commands
      class Invoices < Command
        desc "list", "List invoices"
        option :count
				option :customer
        option :offset

        def list
          super Stripe::Invoice, options
        end

        desc "find ID", "Find an invoice"
        def find invoice_id
          super Stripe::Invoice, invoice_id
        end

				desc "close ID", "close an unpaid invoice"
				def close invoice_id
					super Stripe::Invoice, invoice_id
				end

				desc "pay ID", "trigger an open invoice to be paid immediately"
				def pay invoice_id
					super Stripe::Invoice, invoice_id
				end
      end
    end
  end
end