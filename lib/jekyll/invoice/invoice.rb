module Jekyll
  module Invoice
    class Invoice
      def initialize
        @lines = []
        @rates = {}
      end

      attr_reader :rates

      def add(line)
        @lines << line
      end

      def lines
        @lines
      end

      def set_rate(unit, rate)
        @rates[unit] = rate
      end

      class Processor
        def initialize(invoice)
          @invoice = invoice
        end

        attr_reader :invoice

        def daily_rate(value)
          invoice.set_rate :day, value
        end

        def hourly_rate(value)
          invoice.set_rate :hour, value
        end

        def line(description, options = {})
          if days = options.delete(:days)
            if rate = invoice.rates[:day]
              options[:quantity] = days
              options[:unit] = :day
              options[:rate] = rate
            else
              raise InvoiceError, "days specified, but no prevailing rate established with 'daily_rate'"
            end
          end

          if hours = options.delete(:hours)
            if rate = invoice.rates[:hour]
              options[:quantity] = hours
              options[:unit] = :hour
              options[:rate] = rate
            else
              raise InvoiceError, "hours specified, but no prevailing rate established with 'hourly_rate'"
            end
          end

          if date = options.delete(:date)
            options[:period] = date..date
          end

          invoice.add Line.new(description, options)
        end
      end

      def process(content)
        processor = Processor.new(self)
        processor.instance_eval(content)
      end

      ATTRIBUTES_FOR_LIQUID = %w[
        lines
      ]

      def to_liquid
        Hash[self.class::ATTRIBUTES_FOR_LIQUID.map { |attribute|
          [attribute, send(attribute)]
        } << ['rates', stringify_keys(rates)]
        ]
      end

      def stringify_keys(h)
        Hash[h.map { |k, v| [k.to_s, v] }]
      end
    end
  end
end
