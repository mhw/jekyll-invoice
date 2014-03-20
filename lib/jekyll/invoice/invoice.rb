module Jekyll
  module Invoice
    class Invoice
      attr_accessor :rate

      class Processor
        def initialize(invoice)
          @invoice = invoice
        end

        attr_reader :invoice

        def rate(value)
          invoice.rate = value
        end
      end

      def process(content)
        processor = Processor.new(self)
        processor.instance_eval(content)
      end
    end
  end
end
