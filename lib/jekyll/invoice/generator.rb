module Jekyll
  module Invoice
    class Generator < Jekyll::Generator
      safe true
      priority :low

      def generate(site)
        copy_invoices = []
        site.posts.docs.each do |post|
          if SLUG_MATCHER.match?(post.data["slug"])
            copy_invoices << MakeCopyInvoicePost.new(post).make
          end
        end
        site.posts.docs.concat copy_invoices.compact
      end
    end
  end
end
