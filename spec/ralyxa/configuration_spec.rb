require 'ralyxa/configuration'

RSpec.describe Ralyxa::Configuration do
  subject(:ralyxa_configuration) { Ralyxa::Configuration.new }

  describe '#initialize' do
    it 'sets default configuration values' do
      expect(ralyxa_configuration.validate_requests).to eq(true)
    end
  end

  describe '#validate_requests?' do
    it 'returns the value of validate_request' do
      configuration = ralyxa_configuration
      expect(configuration.validate_requests?).to eq(true)

      configuration.validate_requests = false
      expect(configuration.validate_requests?).to eq(false)

      configuration.validate_requests = 'foo'
      expect(configuration.validate_requests?).to eq('foo')
    end
  end
end