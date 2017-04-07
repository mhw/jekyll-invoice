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
        content
      end
    end
  end
end
