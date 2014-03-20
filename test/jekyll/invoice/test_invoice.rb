require 'test_helper'

module Jekyll
  module Invoice
    describe Invoice do
      let(:invoice) { Invoice.new }

      describe 'daily_rate' do
        it 'should set the prevailing daily payment rate' do
          invoice.process <<-EOI
            daily_rate 600
          EOI
          invoice.daily_rate.must_equal 600
        end
      end

      describe 'hourly_rate' do
        it 'should set the prevailing hourly payment rate' do
          invoice.process <<-EOI
            hourly_rate 60
          EOI
          invoice.hourly_rate.must_equal 60
        end
      end
        end
      end
    end
  end
end
