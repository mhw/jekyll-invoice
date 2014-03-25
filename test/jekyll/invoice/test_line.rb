require 'test_helper'

module Jekyll
  module Invoice
    describe Line do
      let(:invoice)        { Struct.new(:rate, :unit).new(nil, nil) }
      let(:hourly_invoice) { Struct.new(:rate, :unit).new(60, :hour) }

      it 'should calculate amount with no quantity or rate' do
        line = Line.new(invoice, 'Work')
        line.amount.must_equal 0
      end

      it 'should calculate amount with no quantity' do
        line = Line.new(invoice, 'Work', rate: 250)
        line.amount.must_equal 250
      end

      it 'should calculate amount with quantity' do
        line = Line.new(invoice, 'Work', quantity: 5, rate: 250)
        line.amount.must_equal 1250
      end

      it 'should calculate amount with quantity that is a string' do
        line = Line.new(invoice, 'Work', quantity: 'fixed', rate: 1250)
        line.amount.must_equal 1250
      end

      it 'should calculate tax on amount' do
        line = Line.new(invoice, 'Work', rate: 1000)
        line.tax.must_equal 200
        line.tax_rate.must_equal 0.2
      end

      describe 'to_liquid' do
        it 'should return a hash of attributes' do
          line = Line.new(hourly_invoice, 'Work', quantity: 5)
          attrs = line.to_liquid
          attrs['quantity'].must_equal 5
          attrs['unit'].must_equal 'hour'
          attrs['rate'].must_equal 60
        end
      end
    end
  end
end
