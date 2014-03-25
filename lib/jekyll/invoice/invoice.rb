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
        def initialize(description, options = {})
          @description = description
          @quantity    = options[:quantity] || nil
          @rate        = options[:rate] || 0
        end

        attr_reader :description
        attr_reader :quantity, :rate

        def amount
          if quantity && quantity.kind_of?(Numeric)
            quantity * rate
          else
            rate
          end
        end

        def tax
          amount * tax_rate
        end

        def tax_rate
          0.2
        end

        ATTRIBUTES_FOR_LIQUID = %w[
          description
          quantity rate amount tax tax_rate
        ]

        def to_liquid
          Hash[self.class::ATTRIBUTES_FOR_LIQUID.map { |attribute|
            [attribute, send(attribute)]
          }]
        end
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
          invoice.add Line.new(description, options)
        end
      end

      def process(content)
        processor = Processor.new(self)
        processor.instance_eval(content)
      end

      ATTRIBUTES_FOR_LIQUID = %w[
        lines
        daily_rate
        hourly_rate
      ]

      def to_liquid
        Hash[self.class::ATTRIBUTES_FOR_LIQUID.map { |attribute|
          [attribute, send(attribute)]
        }]
      end
    end
  end
end
