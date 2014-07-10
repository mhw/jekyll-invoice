module Jekyll
  module Invoice
    class Generator < Jekyll::Generator
      safe true
      priority :low

      SLUG_MATCHER = /.*-(\d+)/

      def generate(site)
        copy_invoices = []
        site.posts.each do |post|
          if m = SLUG_MATCHER.match(post.slug)
            post.data['invoice_number'] = m[1]
            post.data['copy_invoice'] = false

            copy_invoice = CopyInvoice.new(site, site.source, '', post.name)
            copy_invoice.data['invoice_number'] = m[1]
            copy_invoice.data['copy_invoice'] = true
            copy_invoices << copy_invoice
          end
        end
        site.posts.concat copy_invoices
      end
    end
  end
end
