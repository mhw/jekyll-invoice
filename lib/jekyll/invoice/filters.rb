module Jekyll
  module Invoice
    module Filters
      def effective_date
        @context['page.date'] || Time.now
      end

      def effective(date_ranges, field_list)
        effective_date = self.effective_date
        match = date_ranges.detect do |date_range|
          end_date = date_range["end"]
          range = if end_date.nil?
                    date_range["start"].to_time...Time.now
                  else
                    date_range["start"].to_time...end_date.to_time
                  end
          range.cover?(effective_date)
        end
        field = field_list.split(' ').detect {|f| match.has_key?(f) }
        if field
          match[field]
        else
          match
        end
      end

      def fmt_address(address, separator = ', ')
        address.join(separator)
      end

      def fmt_address_with_postcode(address, separator = ', ')
        [ address[0...-1].join(separator), address[-1] ].join(' ')
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::Invoice::Filters)
