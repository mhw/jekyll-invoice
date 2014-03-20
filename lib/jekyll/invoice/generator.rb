module Jekyll
  module Invoice
    class Generator < Jekyll::Generator
      SLUG_MATCHER = /.*-(\d+)/

      def generate(site)
        site.posts.each do |post|
          if m = SLUG_MATCHER.match(post.slug)
            post.data['invoice_number'] = m[1]
          end
        end
      end
    end
  end
end
