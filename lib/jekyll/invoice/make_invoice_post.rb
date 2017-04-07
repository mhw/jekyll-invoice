module Jekyll
  module Invoice
    SLUG_MATCHER = /.*-(\d+)/

    class MakeInvoicePost
      attr_accessor :post

      def initialize(post)
        @post = post
      end

      def site
        post.site
      end

      def make
        if m = SLUG_MATCHER.match(post.data['slug'])
          post.data['invoice_number'] = m[1]
          post.data['copy_invoice'] = false
          post.data['pdf_url'] = pdf_url(post.url)
          post.data['copy_invoice_url'] = rewrite_filename(post.url, 'copy-', '')
          post.data['copy_invoice_pdf_url'] = pdf_url(post.url, 'copy-')
          post.data['invoice'] = make_invoice
          post.content = site.layouts['invoice-table'].content
        end
      end

      private
      def make_invoice
        invoice = Jekyll::Invoice::Invoice.new(post.date.to_date)
        if tax_rate = site.config['default_tax']
          invoice.tax_type = tax_rate.to_sym
        end
        if tax = site.data['tax']
          invoice.tax_rates = tax['rates']
        end
        invoice.process post.content
        invoice
      end

      private
      def rewrite_filename(src, prefix, ext)
        f = if ext.length > 0
              File.basename(src, '.html') + ext
            else
              File.basename(src)
            end
        f = prefix + f if prefix.length > 0
        File.join(File.dirname(src), f)
      end

      private
      def pdf_url(src, prefix = '')
        f = File.basename(src, '.html') + '.pdf'
        f = prefix + f if prefix.length > 0
        d = File.dirname(src).sub(%r{^/}, '').gsub('/', '-')
        '/pdf/' + d + '-' + f
      end
    end
  end
end
