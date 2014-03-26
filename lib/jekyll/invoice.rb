require "jekyll/invoice/version"
require "jekyll/invoice/converter"
require "jekyll/invoice/filters"
require "jekyll/invoice/generator"
require "jekyll/invoice/invoice"
require "jekyll/invoice/line"

# Monkey patch Jekyll::Site so Jekyll::Invoice::Converter
# can access the Site object.
Jekyll::Site.class_eval do
  alias :instantiate_subclasses_without_jekyll_invoice_hack :instantiate_subclasses

  def instantiate_subclasses(klass)
    instances = instantiate_subclasses_without_jekyll_invoice_hack(klass)
    instances.each do |instance|
      if instance.respond_to?(:site=)
        instance.site = self
      end
    end
    instances
  end
end

# and monkey patch Jekyll::Convertible so we can access
# the Post (or Page) object too.
Jekyll::Convertible.module_eval do
  alias :transform_without_jekyll_invoice_hack :transform

  def transform
    converter.convertible = self if converter.respond_to?(:convertible=)
    transform_without_jekyll_invoice_hack
    converter.convertible = nil  if converter.respond_to?(:convertible=)
  end
end

class InvoiceError < StandardError
end
