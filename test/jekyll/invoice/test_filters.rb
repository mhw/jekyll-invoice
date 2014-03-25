require 'test_helper'

module Jekyll
  module Invoice
    describe Filters do
      include Filters

      describe 'effective' do
        before do
          @context = {}
        end

        def set_effective_date(d)
          @context['page.date'] = Time.parse(d)
        end

        let(:tax)       { load_data('tax.yml') }
        let(:rates)     { tax['rates'] }
        let(:business)  { load_data('business.yml') }
        let(:addresses) { business['addresses'] }

        it 'extracts effective data with only an end date' do
          set_effective_date('2007-01-01')
          effective(rates, 'percentage').must_equal 17.5
          set_effective_date('2008-11-30')
          effective(rates, 'percentage').must_equal 17.5
        end

        it 'extracts effective data with a start and end date' do
          set_effective_date('2008-12-01')
          effective(rates, 'percentage').must_equal 15
          set_effective_date('2009-05-21')
          effective(rates, 'percentage').must_equal 15
          set_effective_date('2009-12-31')
          effective(rates, 'percentage').must_equal 15
        end

        it 'extracts effective data with only a start date' do
          set_effective_date('2011-01-03')
          effective(rates, 'percentage').must_equal 17.5
          set_effective_date('2011-01-04')
          effective(rates, 'percentage').must_equal 20
          set_effective_date('2012-12-31')
          effective(rates, 'percentage').must_equal 20
        end

        it 'extracts data fields in priority order' do
          set_effective_date('2005-01-01')
          effective(addresses, 'trading registered') \
            .must_equal addresses[0]['registered']
          set_effective_date('2010-01-01')
          effective(addresses, 'trading registered') \
            .must_equal addresses[1]['trading']
        end

        it 'uses today as the default effective date' do
          effective(addresses, 'registered') \
            .must_equal addresses[1]['registered']
        end
      end

      let(:address) { [
        '82 Some Street',
        'Happyville',
        'Happyland'
      ] }

      let(:address_with_postcode) { [
        '82 Some Street',
        'Happyville',
        'Happyland',
        'HL4 2BN'
      ] }

      describe 'fmt' do
        it 'passes arguments to Kernel#sprintf' do
          Kernel.stub :sprintf, ->(format, content) {
            format.must_equal 'format'
            content.must_equal 'content'
            'result'
          } do
            fmt('content', 'format').must_equal 'result'
          end
        end

        it 'introduces thousands separators' do
          fmt(12345678.347, '%.2f', ',').must_equal '12,345,678.35'
        end
      end

      describe 'fmt_address' do
        it 'joins lines with comma' do
          fmt_address(address) \
            .must_equal '82 Some Street, Happyville, Happyland'
        end

        it 'joins lines with custom separator' do
          fmt_address(address, ' ') \
            .must_equal '82 Some Street Happyville Happyland'
        end
      end

      describe 'fmt_address_with_postcode' do
        it 'joins lines with comma' do
          fmt_address_with_postcode(address_with_postcode) \
            .must_equal '82 Some Street, Happyville, Happyland HL4 2BN'
        end

        it 'joins lines with custom separator' do
          fmt_address_with_postcode(address_with_postcode, '|') \
            .must_equal '82 Some Street|Happyville|Happyland HL4 2BN'
        end
      end

      describe 'zero_pad' do
        it 'pads a string with leading zeros' do
          zero_pad('123', 8).must_equal '00000123'
        end

        it 'pads empty strings correctly' do
          zero_pad('', 8).must_equal '00000000'
        end

        it 'handles nil gracefully' do
          zero_pad(nil, 8).must_equal '00000000'
        end

        it 'handles being passed something that is not a string' do
          zero_pad(123, 8).must_equal '00000123'
        end

        it 'can be used without an explicit width' do
          zero_pad('123').must_equal '00000123'
        end
      end
    end
  end
end
