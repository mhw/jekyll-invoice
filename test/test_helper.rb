# Work around breaking change in safe_yaml
require 'safe_yaml'
YAML.enable_symbol_parsing!

require 'jekyll-invoice'
require 'minitest/autorun'

def load_data(file)
  YAML.load_file(File.join('templates/uk/_data', file))
end
