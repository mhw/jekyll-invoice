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

      it 'hooks converter into Jekyll build process' do
        test_dir = File.expand_path('../../fixtures/test-dir', File.dirname(__FILE__))
        proc {
          options = {
            'source' => test_dir,
            'destination' => File.join(test_dir, '_site')
          }
          options = Jekyll.configuration(options)
          Jekyll::Commands::Build.process(options)
        }.must_output /Generating\.\.\. done\./

        out = YAML.load_file(File.join(test_dir, '_site/2014/03/12/invoice-125.html'))
        out['rate'].must_equal 400
        out['lines'].size.must_equal 3
        out['lines'][0].must_equal({
          'description' => 'No quantity or rate',
          'quantity' => nil,
          'rate' => 0,
          'amount' => 0,
          'tax' => 0,
          'tax_rate' => 0.2
        })
        out['lines'][1].must_equal({
          'description' => 'Schedule 1: Ruby development',
          'quantity' => nil,
          'rate' => 2400,
          'amount' => 2400,
          'tax' => 480,
          'tax_rate' => 0.2
        })
        out['lines'][2].must_equal({
          'description' => 'Additional work',
          'quantity' => 2,
          'rate' => 400,
          'amount' => 800,
          'tax' => 160,
          'tax_rate' => 0.2
        })
      end
    end
  end
end
