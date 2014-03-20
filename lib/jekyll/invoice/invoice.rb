module Jekyll
  module Invoice
    class Invoice
      attr_accessor :daily_rate, :hourly_rate

      class Processor
        def initialize(invoice)
          @invoice = invoice
        end

        attr_reader :invoice

        def daily_rate(value)
          invoice.daily_rate = value
        end

        def hourly_rate(value)
          invoice.hourly_rate = value
        end
        end
      end

      def process(content)
        processor = Processor.new(self)
        processor.instance_eval(content)
      end
    end
  end
end
