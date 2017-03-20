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
        let(:customers) { load_data('customers.yml') }

        it 'uses effective date from context' do
          set_effective_date('2007-01-01')
          effective(rates).must_equal 'vat' => 17.5
          set_effective_date('2009-05-21')
          effective(rates).must_equal 'vat' => 15
          set_effective_date('2012-12-31')
          effective(rates).must_equal 'vat' => 20
        end

        it 'uses today as a default effective date' do
          effective(rates).must_equal 'vat' => 20
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

        it 'defaults to entry with no effective date' do
          set_effective_date('2016-06-01')
          effective(customers['flat'], 'address')
            .must_equal customers['flat']['address']
        end

        it 'finds effective address if structured correctly' do
          set_effective_date('2016-06-01')
          effective(customers['effective'], 'address')
            .must_equal customers['effective'][0]['address']
          set_effective_date('2017-06-01')
          effective(customers['effective'], 'address')
            .must_equal customers['effective'][1]['address']
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

        it 'tolerates nil content' do
          fmt(nil, '%.2f', ',').must_equal '0.00'
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
