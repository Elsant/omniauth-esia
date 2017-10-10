$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)

require 'omniauth-esia'

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!
  config.extend  OmniAuth::Test::StrategyMacros, type: :strategy

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
