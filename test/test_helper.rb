module Liquid
  module Template
    def register_filter(mod)
    end

    module_function :register_filter
  end
end

require 'jekyll-invoice'
require 'minitest/autorun'
