require "jekyll/invoice/version"
require "jekyll/invoice/utils"
require "jekyll/invoice/converter"
require "jekyll/invoice/filters"
require "jekyll/invoice/copy_invoice"
require "jekyll/invoice/generator"
require "jekyll/invoice/invoice"
require "jekyll/invoice/line"
require "jekyll/invoice/make_invoice_post"
require "jekyll/invoice/make_copy_invoice_post"

Jekyll::Hooks.register :site, :post_read do |site|
  site.posts.docs.each do |post|
    Jekyll::Invoice::MakeInvoicePost.new(post).make
  end
end

Jekyll::Hooks.register :posts, :pre_render do |post, payload|
  payload["invoice"] = post.data["invoice"]
end

class InvoiceError < StandardError
end
