module Jekyll
  module Invoice
    class Invoice
      def initialize
        @lines = []
      end

      attr_accessor :unit, :rate

      def add(line)
        @lines << line
      end

      def lines
        @lines
      end

      class Processor
        def initialize(invoice)
          @invoice = invoice
        end

        attr_reader :invoice

        def daily_rate(value)
          invoice.unit = :day
          invoice.rate = value
        end

        def hourly_rate(value)
          invoice.unit = :hour
          invoice.rate = value
        end

        def line(description, options = {})
          invoice.add Line.new(invoice, description, options)
        end
      end

      def process(content)
        processor = Processor.new(self)
        processor.instance_eval(content)
      end

      ATTRIBUTES_FOR_LIQUID = %w[
        lines
        unit rate
      ]

      def to_liquid
        Hash[self.class::ATTRIBUTES_FOR_LIQUID.map { |attribute|
          [attribute, send(attribute)]
        }]
      end
    end
  end
end
