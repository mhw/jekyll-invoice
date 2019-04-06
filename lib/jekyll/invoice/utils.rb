module Jekyll
  module Invoice
    module Utils
      module_function

      def effective(date_ranges, effective_date)
        return date_ranges unless date_ranges.is_a?(Array)
        match = date_ranges.detect { |date_range|
          s = date_range["start"]
          e = date_range["end"]
          if s.nil?
            effective_date <= e
          elsif e.nil?
            s <= effective_date
          else
            (s..e).cover? effective_date
          end
        }
        match.reject { |k, v| %w[start end].include?(k) }
      end
    end
  end
end
