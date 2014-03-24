module Jekyll
  module Invoice
    class Converter < Jekyll::Converter
      safe false
      priority :low

      attr_accessor :site

      def matches(ext)
        ext =~ /^\.invoice$/i
      end

      def output_ext(ext)
        '.html'
      end

      def convert(content)
        invoice = Invoice.new
        invoice.process content

        layout = site.layouts['invoice-table']
        payload = { 'invoice' => invoice }
        info = { :filters => [Jekyll::Filters], :registers => { :site => self.site } }
        Liquid::Template.parse(layout.content).render!(payload, info)
      end
    end
  end
end
