module Jekyll
  module Invoice
    module Filters
      def effective_date
        @context["page.date"] || Time.now
      end

      def effective(date_ranges, field_list = "")
        match = Utils.effective(date_ranges, effective_date.to_date)
        field = field_list.split(" ").detect {|f| match.key?(f) }
        if field
          match[field]
        else
          match
        end
      end

      def fmt(content, format, separator = nil)
        content ||= 0
        result = Kernel.sprintf(format, content)
        if separator
          result.gsub!(/(?<=\d)(?=(\d\d\d)+(?!\d))/, separator)
        end
        result
      end

      def fmt_address(address, separator = ", ")
        if address.nil?
          "No address passed to 'fmt_address'"
        else
          address.join(separator)
        end
      end

      def fmt_address_with_postcode(address, separator = ", ")
        [address[0...-1].join(separator), address[-1]].join(" ")
      end

      def zero_pad(s, width = 8)
        s = if s.nil?
          ""
        else
          s.to_s
        end
        ("0" * width + s)[-width..-1]
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::Invoice::Filters)
