require 'test_helper'

module Jekyll
  module Invoice
    describe Filters do
      include Filters

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

      describe 'fmt_address' do
        it 'joins lines with comma' do
          fmt_address(address).must_equal '82 Some Street, Happyville, Happyland'
        end

        it 'joins lines with custom separator' do
          fmt_address(address, ' ').must_equal '82 Some Street Happyville Happyland'
        end
      end

      describe 'fmt_address_with_postcode' do
        it 'joins lines with comma' do
          fmt_address_with_postcode(address_with_postcode).must_equal '82 Some Street, Happyville, Happyland HL4 2BN'
        end

        it 'joins lines with custom separator' do
          fmt_address_with_postcode(address_with_postcode, '|').must_equal '82 Some Street|Happyville|Happyland HL4 2BN'
        end
      end
    end
  end
end
