require 'test_helper'

module Jekyll
  module Invoice
    describe Generator do
      describe 'invoice number' do
        Site = Struct.new(:posts)
        Post = Struct.new(:slug, :data)

        let(:g)    { Generator.new }
        let(:site) { Site.new([Post.new('', {})]) }

        def set_slug(slug)
          site.posts[0].slug = slug
        end

        it 'extracts invoice number from properly formatted slug' do
          set_slug 'invoice-123'
          g.generate(site)
          site.posts[0].data['invoice_number'].must_equal '123'
        end

        it 'ignores slugs that are not formatted as invoices' do
          set_slug 'first-post'
          g.generate(site)
          site.posts[0].data['invoice_number'].must_be_nil
        end
      end
    end
  end
end
