module Jekyll
  module Invoice
    module Filters
      def effective_date
        @context['page.date'] || Time.now
      end

      def effective(date_ranges, field_list)
        effective_date = self.effective_date.to_date
        match = date_ranges.detect do |date_range|
          s = date_range['start']
          e = date_range['end']
          if s.nil?
            effective_date <= e
          elsif e.nil?
            s <= effective_date
          else
            (s..e).cover? effective_date
          end
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

      def zero_pad(s, width = 8)
        s = if s.nil?
              ''
            else
              s.to_s
            end
        ('0' * width + s)[-width..-1]
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::Invoice::Filters)
