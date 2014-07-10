module Jekyll
  module Invoice
    class CopyInvoice < Post
      def process(name)
        super(name)
        self.slug = "copy-#{self.slug}"
      end
    end
  end
end
