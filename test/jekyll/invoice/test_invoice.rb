require 'test_helper'

module Jekyll
  module Invoice
    describe Invoice do
      let(:invoice) { Invoice.new }

      describe 'rate' do
        it 'should set the prevailing payment rate' do
          invoice.process <<-EOI
            rate 60
          EOI
          invoice.rate.must_equal 60
        end
      end
    end
  end
end
