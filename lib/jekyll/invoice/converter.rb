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
        invoice = Invoice.new
        if convertible.respond_to?(:date)
          invoice.date = convertible.date
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
