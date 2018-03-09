require 'simplecov'
SimpleCov.start do
  add_filter %r{^/spec/}
end

require 'ralyxa'
require 'vcr'
require 'timecop'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  Dir["./spec/support/**/*.rb"].each {|f| require f}

  config.before :each do
    Ralyxa.configure do |config|
      config.validate_requests = false
      config.require_secure_urls = false
    end
  end
end

RSpec::Expectations.configuration.on_potential_false_positives = :nothing

VCR.configure do |config|
  config.cassette_library_dir = './spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
end