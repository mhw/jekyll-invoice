require 'test_helper'

module Jekyll
  module Invoice
    describe Utils do
      describe 'effective' do
        let(:rates) { load_data('tax.yml')['rates'] }

        def d(s)
          Date.parse(s)
        end

        it 'extracts effective data with only an end date' do
          Utils.effective(rates, d('2007-01-01')).must_equal 'vat' => 17.5
          Utils.effective(rates, d('2008-11-30')).must_equal 'vat' => 17.5
        end

        it 'extracts effective data with a start and end date' do
          Utils.effective(rates, d('2008-12-01')).must_equal 'vat' => 15
          Utils.effective(rates, d('2009-05-21')).must_equal 'vat' => 15
          Utils.effective(rates, d('2009-12-31')).must_equal 'vat' => 15
        end

        it 'extracts effective data with only a start date' do
          Utils.effective(rates, d('2011-01-03')).must_equal 'vat' => 17.5
          Utils.effective(rates, d('2011-01-04')).must_equal 'vat' => 20
          Utils.effective(rates, d('2012-12-31')).must_equal 'vat' => 20
        end

        it 'does not change the data passed to it' do
          # Need to go deep enough to duplicate the hashes in the array.
          initial = rates.map { |r| r.dup }
          Utils.effective(rates, d('2009-05-21')).must_equal 'vat' => 15
          rates.must_equal initial
        end
      end
    end
  end
end

