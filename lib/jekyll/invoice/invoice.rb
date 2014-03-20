module Jekyll
  module Invoice
    class Invoice
      def initialize
        @lines = []
      end

      attr_accessor :daily_rate, :hourly_rate

      def add(line)
        @lines << line
      end

      def lines
        @lines
      end

      class Line
        def initialize(description)
          @description = description
        end

        attr_reader :description
      end

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

        def line(description, options = {})
          invoice.add Line.new(description)
        end
      end

      def process(content)
        processor = Processor.new(self)
        processor.instance_eval(content)
      end
    end
  end
end
