# Work around breaking change in safe_yaml
require 'safe_yaml'
SafeYAML::OPTIONS[:deserialize_symbols] = true

require 'jekyll-invoice'
require 'minitest/autorun'

def load_data(file)
  YAML.load_file(File.join('test/fixtures/_data', file))
end
