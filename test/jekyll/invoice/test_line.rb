require 'test_helper'

module Jekyll
  module Invoice
    describe Line do
      it 'should calculate amount with no quantity or rate' do
        line = Line.new('Work')
        line.amount.must_equal 0
      end

      it 'should calculate amount with no quantity' do
        line = Line.new('Work', rate: 250)
        line.amount.must_equal 250
      end

      it 'should calculate amount with quantity' do
        line = Line.new('Work', quantity: 5, rate: 250)
        line.amount.must_equal 1250
      end

      it 'should calculate amount with quantity that is a string' do
        line = Line.new('Work', quantity: 'fixed', rate: 1250)
        line.amount.must_equal 1250
      end

      it 'should calculate tax on amount' do
        line = Line.new('Work', rate: 1000)
        line.tax.must_equal 200
        line.tax_rate.must_equal 0.2
      end
    end
  end
end
