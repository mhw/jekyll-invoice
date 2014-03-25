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
          invoice.rate.must_equal 600
          invoice.unit.must_equal :day
        end
      end

      describe 'hourly_rate' do
        it 'should set the prevailing hourly payment rate' do
          invoice.process <<-EOI
            hourly_rate 60
          EOI
          invoice.rate.must_equal 60
          invoice.unit.must_equal :hour
        end
      end

      describe 'line' do
        it 'should add a line to the invoice' do
          invoice.lines.size.must_equal 0
          invoice.process <<-EOI
            line 'Do some work'
          EOI
          invoice.lines.size.must_equal 1
        end

        it 'should add lines in order' do
          invoice.lines.size.must_equal 0
          invoice.process <<-EOI
            line 'Do some work'
            line 'More work'
          EOI
          invoice.lines.size.must_equal 2
          invoice.lines.map(&:description) \
            .must_equal ['Do some work', 'More work']
        end

        it 'should pass options to line' do
          invoice.process <<-EOI
            line 'Do some work', quantity: 5, rate: 250
          EOI
          invoice.lines[0].quantity.must_equal 5
          invoice.lines[0].rate.must_equal 250
        end

        it 'should allow line to initialize from invoice data' do
          invoice.process <<-EOI
            hourly_rate 60

            line 'Do some work', quantity: 5
          EOI
          invoice.lines[0].quantity.must_equal 5
          invoice.lines[0].unit.must_equal :hour
          invoice.lines[0].rate.must_equal 60
        end
      end

      describe 'to_liquid' do
        it 'should return a hash of attributes' do
          invoice.process <<-EOI
            daily_rate 600

            line 'Do some work'
          EOI
          attrs = invoice.to_liquid
          attrs['unit'].must_equal :day
          attrs['rate'].must_equal 600
          attrs['lines'].must_be_instance_of Array
        end
      end
    end
  end
end
