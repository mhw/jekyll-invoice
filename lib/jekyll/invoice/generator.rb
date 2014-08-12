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
            post.data['pdf_url'] = rewrite_filename(post.url, '', '.pdf')
            post.data['copy_invoice_url'] = rewrite_filename(post.url, 'copy-', '')
            post.data['copy_invoice_pdf_url'] = rewrite_filename(post.url, 'copy-', '.pdf')

            copy_invoice_class = if post.kind_of? Draft
                                   CopyDraftInvoice
                                 else
                                   CopyInvoice
                                 end
            copy_invoice = copy_invoice_class.new(site, site.source, '', post.name)
            copy_invoice.data['invoice_number'] = m[1]
            copy_invoice.data['copy_invoice'] = true
            copy_invoices << copy_invoice
          end
        end
        site.posts.concat copy_invoices
      end

      def rewrite_filename(src, prefix, ext)
        f = if ext.length > 0
              File.basename(src, '.html') + ext
            else
              File.basename(src)
            end
        f = prefix + f if prefix.length > 0
        File.join(File.dirname(src), f)
      end
    end
  end
end
