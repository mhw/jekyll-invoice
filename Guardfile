# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :minitest, all_after_pass: true do
  watch(%r{^test/(.*)\/?test_(.*)\.rb$})
  watch(%r{^test/fixtures/[^/]+/(?!_site/)}) { 'test/jekyll/invoice/test_converter.rb' }
  watch(%r{^lib/(.*/)?([^/]+)\.rb$})     { |m| "test/#{m[1]}test_#{m[2]}.rb" }
  watch(%r{^test/test_helper\.rb$})      { 'test' }
end
