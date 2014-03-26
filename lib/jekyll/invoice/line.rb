module Jekyll
  module Invoice
    class Line
      def initialize(description, options = {})
        @description = description
        @quantity    = options[:quantity] || nil
        @unit        = options[:unit] || ''
        @rate        = options[:rate] || 0
      end

      attr_reader :description
      attr_reader :quantity, :unit, :rate

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
        } << ['unit', unit.to_s]
        ]
      end
    end
  end
end
