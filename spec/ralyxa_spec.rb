require "spec_helper"

RSpec.describe Ralyxa do
  it "has a version number" do
    expect(Ralyxa::VERSION).not_to be nil
  end

  describe '#configure' do
    before :each do
      Ralyxa.configuration = Ralyxa::Configuration.new
    end

    context 'with a block' do
      it 'sets configuration values as expected' do
        Ralyxa.configure { |c| c.validate_requests = 'foo' }

        expect(Ralyxa.configuration.validate_requests).to eq('foo')
      end
    end

    context 'without a block' do
      it 'does not raise a LocalJumpError' do
        expect{ Ralyxa.configure }.not_to raise_error(LocalJumpError, 'no block given (yield)')
      end
    end
  end

  describe '#method_missing' do
    before :each do
      Ralyxa.configuration = Ralyxa::Configuration.new
    end

    it 'passes Ralyxa::Configuration methods through' do
      expect(Ralyxa.validate_requests?).to eq(true)
      Ralyxa.validate_requests = 'foo'
      expect(Ralyxa.validate_requests).to eq('foo')
    end

    it 'raises the expected method missing error for a genuinely missing method' do
      expect{ Ralyxa.foo }.to raise_error(NoMethodError, 'undefined method `foo\' for Ralyxa:Module')
    end
  end

  describe '#respond_to_missing' do
    it 'correctly responds to methods from Ralyxa::Configuration' do
      expect(Ralyxa.respond_to?(:validate_requests)).to eq(true)
      expect(Ralyxa.respond_to?(:validate_requests=)).to eq(true)
      expect(Ralyxa.respond_to?(:validate_requests?)).to eq(true)
    end
  end
end
