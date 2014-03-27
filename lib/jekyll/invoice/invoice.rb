module Jekyll
  module Invoice
    class Invoice
      def initialize(date)
        @date = date
        @lines = []
        @rates = {}
        @tax_rates = {}
      end

      attr_reader :date, :lines, :rates, :tax_rates
      attr_accessor :tax_type

      def add(line)
        @lines << line
      end

      def set_rate(unit, rate)
        @rates[unit] = rate
      end

      def tax_rates=(tax_rates)
        @tax_rates = Utils.effective(tax_rates, date)
      end

      def tax_rate
        if tax_type
          tax_rates[tax_type.to_s]
        else
          0
        end
      end

      def net_total
        @lines.map(&:amount).reduce(0, :+)
      end

      def tax
        @lines.map(&:tax).reduce(0, :+)
      end

      def total
        net_total + tax
      end

      class Processor
        def initialize(invoice)
          @invoice = invoice
        end

        attr_reader :invoice

        def tax(type)
          invoice.tax_type = type
        end

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
          if period = options[:period]
            options[:period] = convert_dates(period)
          end

          options[:tax_rate] = invoice.tax_rate / 100.0 unless options.has_key?(:tax_rate)

          invoice.add Line.new(description, options)
        end

        private
          def convert_dates(o)
            case o
            when Range then convert_dates(o.first)..convert_dates(o.last)
            when String then Date.parse(o)
            else o
            end
          end
      end

      def process(content)
        processor = Processor.new(self)
        processor.instance_eval(content)
      end

      ATTRIBUTES_FOR_LIQUID = %w[
        date lines tax_type tax_rate
        net_total tax total
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
