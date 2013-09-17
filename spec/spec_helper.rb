$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'sox'
require 'rspec'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}


FIXTURES_PATH = File.expand_path('../integration/fixtures', __FILE__)

RSpec.configure do |config|
  def input_fixture(file)
    File.join(FIXTURES_PATH, 'input', file)
  end

  def output_fixture(file)
    File.join(FIXTURES_PATH, 'output', file)
  end

  def gen_tmp_filename(ext = 'mp3')
    Dir::Tmpname.make_tmpname ['/tmp/ruby-sox-test', ".#{ext}"], nil
  end
end
