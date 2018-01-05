require 'ralyxa/configuration'

RSpec.describe Ralyxa::Configuration do
  subject(:ralyxa_configuration) { Ralyxa::Configuration.new }

  describe '#initialize' do
    it 'sets default configuration values' do
      expect(ralyxa_configuration.validate_requests).to eq(true)
      expect(ralyxa_configuration.require_secure_urls).to eq(true)
    end
  end

  describe '#validate_requests?' do
    it_should_behave_like 'a configuration option', :validate_requests
  end

  describe '#require_secure_urls?' do
    it_should_behave_like 'a configuration option', :require_secure_urls
  end
end