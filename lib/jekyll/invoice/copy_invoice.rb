module Jekyll
  module Invoice
    module CopyInvoiceMixin
      def populate_title
        super
        if (slug = data["slug"])
          slug = "copy-#{slug}"
          data["slug"] = slug
          data["title"] = Jekyll::Utils.titleize_slug(slug)
        end
      end
    end

    class CopyDocument < Document
      include CopyInvoiceMixin
    end
  end
end
