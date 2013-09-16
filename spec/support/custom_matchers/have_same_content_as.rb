RSpec::Matchers.define :have_same_content_as do |expected_file|
  match do |file|
    File.binread(file) == File.binread(expected_file)
  end
end
