require 'test_helper'

module Jekyll
  module Invoice
    describe Line do
      it 'should calculate amount with no quantity or rate' do
        line = Line.new('Work')
        line.quantity.must_equal nil
        line.unit.must_equal nil
        line.rate.must_equal 0
        line.amount.must_equal 0
      end

      it 'should calculate amount with no quantity' do
        line = Line.new('Work', rate: 250)
        line.quantity.must_equal nil
        line.unit.must_equal nil
        line.amount.must_equal 250
      end

      it 'should calculate amount with quantity' do
        line = Line.new('Work', quantity: 5, rate: 250)
        line.quantity.must_equal 5
        line.unit.must_equal nil
        line.amount.must_equal 1250
      end

      it 'should calculate amount with quantity that is a string' do
        line = Line.new('Work', quantity: 'fixed', rate: 1250)
        line.quantity.must_equal 'fixed'
        line.unit.must_equal nil
        line.amount.must_equal 1250
      end

      it 'should calculate tax on amount' do
        line = Line.new('Work', rate: 1000, tax_rate: 0.2)
        line.tax.must_equal 200
        line.tax_rate.must_equal 0.2
      end

      it 'should explode period into start and end' do
        line = Line.new('Work', period: Date.new(2014, 3, 17)..Date.new(2014, 3, 23))
        line.start_date.must_equal Date.new(2014, 3, 17)
        line.end_date.must_equal Date.new(2014, 3, 23)
      end

      describe 'to_liquid' do
        it 'should return a hash of attributes' do
          line = Line.new('Work', quantity: 5, unit: :hour, rate: 60, tax_rate: 0.2,
                          period: Date.new(2014, 3, 17)..Date.new(2014, 3, 23))
          attrs = line.to_liquid
          attrs['description'].must_equal 'Work'
          attrs['quantity'].must_equal 5
          attrs['unit'].must_equal 'hour'
          attrs['rate'].must_equal 60
          attrs['amount'].must_equal 300
          attrs['tax'].must_equal 60
          attrs['tax_rate'].must_equal 0.2
          attrs['start_date'].must_equal Date.new(2014, 3, 17)
          attrs['end_date'].must_equal Date.new(2014, 3, 23)
        end

        it 'should set the unit attribute to nil if not specified' do
          line = Line.new('Work', quantity: 'fixed', rate: 1000)
          attrs = line.to_liquid
          attrs['unit'].must_equal nil
        end
      end
    end
  end
end
