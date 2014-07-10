require 'test_helper'

module Jekyll
  module Invoice
    describe Converter do
      let(:conv) { Converter.new }

      it 'recognises .invoice files' do
        conv.matches('.invoice').must_equal 0
      end

      it 'ignores .markdown files' do
        conv.matches('.markdown').must_be_nil
      end

      def process_fixture_site(name)
        test_dir = File.expand_path("../../fixtures/#{name}", File.dirname(__FILE__))
        proc {
          options = {
            'source' => test_dir,
            'destination' => File.join(test_dir, '_site')
          }
          options = Jekyll.configuration(options)
          Jekyll::Commands::Build.process(options)
        }.must_output /Generating\.\.\. done\./
        test_dir
      end

      it 'hooks converter into Jekyll build process' do
        test_dir = process_fixture_site('test-dir')
        out = YAML.load_file(File.join(test_dir, '_site/2014/03/12/invoice-125.html'))
        out['date'].must_equal '12/03/14'
        out['invoice_number'].must_equal 125
        out['copy_invoice'].must_equal false
        out['rate'].must_equal 400
        out['tax_rate'].must_equal 20
        out['lines'].size.must_equal 3
        out['lines'][0].must_equal({
          'description' => 'No quantity or rate',
          'quantity' => nil,
          'rate' => 0,
          'amount' => 0,
          'tax' => 0,
          'tax_rate' => 0
        })
        out['lines'][1].must_equal({
          'description' => 'Schedule 1: Ruby development',
          'quantity' => nil,
          'rate' => 2400,
          'amount' => 2400,
          'tax' => 480,
          'tax_rate' => 20
        })
        out['lines'][2].must_equal({
          'description' => 'Additional work',
          'quantity' => 2,
          'rate' => 400,
          'amount' => 800,
          'tax' => 160,
          'tax_rate' => 20
        })
        out['net_total'].must_equal 3200
        out['tax'].must_equal 640
        out['total'].must_equal 3840
      end

      it 'gets default tax rate from _config.yml if available' do
        test_dir = process_fixture_site('test-dir-with-default-tax-rate')
        out = YAML.load_file(File.join(test_dir, '_site/2014/03/12/invoice-125.html'))
        out['tax_rate'].must_equal 20
        out['lines'].size.must_equal 3
        out['lines'][0]['tax_rate'].must_equal 20
        out['lines'][1]['tax_rate'].must_equal 20
        out['lines'][2]['tax_rate'].must_equal 20
      end

      it 'creates a copy invoice as well' do
        test_dir = process_fixture_site('test-dir')
        out = YAML.load_file(File.join(test_dir, '_site/2014/03/12/copy-invoice-125.html'))
        out['date'].must_equal '12/03/14'
        out['invoice_number'].must_equal 125
        out['copy_invoice'].must_equal true
      end
    end
  end
end
