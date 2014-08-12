module Jekyll
  module Invoice
    module CopyInvoiceMixin
      def process(name)
        super(name)
        self.slug = "copy-#{self.slug}"
      end
    end

    class CopyInvoice < Post
      include CopyInvoiceMixin
    end

    class CopyDraftInvoice < Draft
      include CopyInvoiceMixin
    end
  end
end
