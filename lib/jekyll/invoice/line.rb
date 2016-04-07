require 'bigdecimal'

module Jekyll
  module Invoice
    class Line
      def initialize(description, options = {})
        @description = description
        @quantity    = options[:quantity] || nil
        @unit        = options[:unit] || nil
        @rate        = options[:rate] || 0
        @tax_rate    = options[:tax_rate] || 0
        if p = options[:period]
          @start_date = p.first
          @end_date   = p.last
        end

        if @quantity.kind_of? Numeric
          q = BigDecimal.new(@quantity, 5)
          if q.frac.zero?
            @quantity = q.floor
          end
        end
      end

      attr_reader :description
      attr_reader :quantity, :unit, :rate, :tax_rate
      attr_reader :start_date, :end_date

      def amount
        if quantity && quantity.kind_of?(Numeric)
          quantity * rate
        else
          rate
        end
      end

      def tax
        amount * tax_rate / 100.0
      end

      ATTRIBUTES_FOR_LIQUID = %w[
        description
        quantity rate amount tax tax_rate
        start_date end_date
      ]

      def to_liquid
        Hash[self.class::ATTRIBUTES_FOR_LIQUID.map { |attribute|
          [attribute, send(attribute)]
        }].merge({
          'unit' => unit ? unit.to_s : nil
        })
      end
    end
  end
end
