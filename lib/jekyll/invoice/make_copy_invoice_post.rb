module Jekyll
  module Invoice
    class MakeCopyInvoicePost
      attr_accessor :post

      def initialize(post)
        @post = post
      end

      def make
        copy_invoice = nil
        if post.data['invoice']
          copy_invoice = Document.new(post.path, site: post.site,
                                      collection: post.collection)
          copy_invoice.merge_data!(post.data, source: 'original invoice')
          copy_invoice.data['copy_invoice'] = true
          slug = "copy-#{post.data['slug']}"
          copy_invoice.data['slug'] = slug
          copy_invoice.data["title"] = Jekyll::Utils.titleize_slug(slug)
          copy_invoice.content = post.content
        end
        copy_invoice
      end
    end
  end
end
