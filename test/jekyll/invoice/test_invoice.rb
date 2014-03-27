require 'test_helper'

module Jekyll
  module Invoice
    describe Invoice do
      let(:invoice) { Invoice.new(Date.new(2013, 4, 24)) }

      describe 'daily_rate' do
        it 'should set the prevailing daily payment rate' do
          invoice.process <<-EOI
            daily_rate 600
          EOI
          invoice.rates[:day].must_equal 600
        end
      end

      describe 'hourly_rate' do
        it 'should set the prevailing hourly payment rate' do
          invoice.process <<-EOI
            hourly_rate 60
          EOI
          invoice.rates[:hour].must_equal 60
        end

        it 'should co-exist with daily_rate' do
          invoice.process <<-EOI
            daily_rate 600
            hourly_rate 60
          EOI
          invoice.rates[:day].must_equal 600
          invoice.rates[:hour].must_equal 60
        end
      end

      describe 'tax' do
        describe 'with no rates loaded' do
          it 'should default to no tax type' do
            invoice.tax_type.must_equal nil
            invoice.tax_rate.must_equal 0
          end
        end

        describe 'with rates loaded' do
          before do
            invoice.tax_rates = load_data('tax.yml')['rates']
          end

          it 'should select the effective tax rates' do
            invoice.tax_rates.must_equal 'vat' => 20
          end

          it 'should set the prevailing type of tax' do
            invoice.process <<-EOI
              tax :vat
            EOI
            invoice.tax_type.must_equal :vat
            invoice.tax_rate.must_equal 20
          end
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

        it 'should set tax rate set by the invoice' do
          invoice.tax_rates = load_data('tax.yml')['rates']
          invoice.process <<-EOI
            tax :vat

            line 'Do some work', rate: 1000
          EOI
          invoice.lines[0].tax_rate.must_equal 20
        end

        it 'should support syntactic sugar for hours' do
          invoice.process <<-EOI
            hourly_rate 60
            line 'Do some work', hours: 4
          EOI
          invoice.lines[0].quantity.must_equal 4
          invoice.lines[0].unit.must_equal :hour
          invoice.lines[0].rate.must_equal 60
        end

        it 'should report an error if no prevailing rate was established' do
          e = proc {
            invoice.process <<-EOI
              daily_rate 400
              line 'Do some work', hours: 4
            EOI
          }.must_raise InvoiceError
          e.message.must_match /hours/
        end

        it 'should support syntactic sugar for single days' do
          invoice.process <<-EOI
            line 'Work', date: Date.new(2014, 2, 19)
          EOI
          invoice.lines[0].start_date.must_equal Date.new(2014, 2, 19)
          invoice.lines[0].end_date.must_equal invoice.lines[0].start_date
        end

        it 'should support syntactic sugar for date ranges' do
          invoice.process <<-EOI
            line 'Work', period: '2014-3-10'..'2014-03-16'
          EOI
          invoice.lines[0].start_date.must_equal Date.new(2014, 3, 10)
          invoice.lines[0].end_date.must_equal Date.new(2014, 3, 16)
        end

        it 'should support syntactic sugar for single days' do
          invoice.process <<-EOI
            line 'Work', date: '2014-3-10'
          EOI
          invoice.lines[0].start_date.must_equal Date.new(2014, 3, 10)
          invoice.lines[0].end_date.must_equal invoice.lines[0].start_date
        end
      end

      describe 'total calculations' do
        before do
          invoice.tax_rates = load_data('tax.yml')['rates']
        end

        it 'should total the amounts from each line' do
          invoice.process <<-EOI
            tax :vat
            daily_rate 400
            hourly_rate 60
            line 'Work', rate: 2000
            line 'More work', hours: 5
            line 'More work', days: 2
          EOI
          net_total = 2000+5*60+2*400
          invoice.net_total.must_equal net_total
          invoice.tax.must_equal net_total * 0.2
          invoice.total.must_equal net_total * 1.2
        end
      end

      describe 'to_liquid' do
        before do
          invoice.tax_rates = load_data('tax.yml')['rates']
        end

        it 'should return a hash of attributes' do
          invoice.process <<-EOI
            tax :vat
            daily_rate 600

            line 'Do some work', rate: 2000
          EOI
          attrs = invoice.to_liquid
          attrs['lines'].must_be_instance_of Array
          attrs['rates'].must_equal({
            'day' => 600
          })
          attrs['net_total'].must_equal 2000
          attrs['tax'].must_equal 400
          attrs['total'].must_equal 2400
        end

        it 'should return a hash of attributes even when invoice is empty' do
          attrs = invoice.to_liquid
          attrs['lines'].must_equal []
          attrs['rates'].must_equal Hash.new
          attrs['net_total'].must_equal 0
          attrs['tax'].must_equal 0
          attrs['total'].must_equal 0
        end
      end
    end
  end
end
