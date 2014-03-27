module Jekyll
  module Invoice
    class Converter < Jekyll::Converter
      safe false
      priority :low

      attr_accessor :site
      attr_accessor :convertible

      def matches(ext)
        ext =~ /^\.invoice$/i
      end

      def output_ext(ext)
        '.html'
      end

      def convert(content)
        effective_date = if convertible.respond_to?(:date)
                           convertible.date.to_date
                         else
                           Date.today
                         end
        invoice = Invoice.new(effective_date)
        if tax_rate = site.config['default_tax']
          invoice.tax_type = tax_rate.to_sym
        end
        if tax = site.data['tax']
          invoice.tax_rates = tax['rates']
        end
        invoice.process content

        layout = site.layouts['invoice-table']
        payload = { 'invoice' => invoice }
        info = { :filters => [Jekyll::Filters], :registers => { :site => self.site } }
        Liquid::Template.parse(layout.content).render!(payload, info)
      end
    end
  end
end
