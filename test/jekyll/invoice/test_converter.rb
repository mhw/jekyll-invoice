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
        options = {
          'source' => test_dir,
          'destination' => File.join(test_dir, '_site')
        }
        options = Jekyll.configuration(options)
        Jekyll::Commands::Build.process(options)

        out = YAML.load_file(File.join(test_dir, '_site/2014/03/12/invoice-125.html'))
        out['daily_rate'].must_equal 400
        out['lines'].size.must_equal 2
        out['lines'][0]['description'].must_equal 'Schedule 1: Ruby development'
        out['lines'][1]['description'].must_equal 'Additional work'
      end
    end
  end
end
