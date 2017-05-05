require 'alexa/register_intents'

RSpec.describe Alexa::RegisterIntents do
  describe '#run' do
    it 'registers intents declared inside the "intents" directory to the skill' do
      fixtures_path  = "./spec/fixtures/intents"
      fixtures_files = Dir.glob("#{fixtures_path}/*.rb")
      fixtures       = fixtures_files.map { |fixture_file| File.open(File.expand_path(fixture_file)).read }
      alexa_skill_class = double(:"Alexa::Skill")

      fixtures.each do |fixture|
        expect(alexa_skill_class).to receive(:class_eval).with(fixture)
      end

      service = described_class.new(fixtures_path, alexa_skill_class)
      service.run
    end

    it 'warns if no intents declarations are found' do
      fixtures_path = "./spec/fixtures/empty"
      service       = described_class.new(fixtures_path, double(:"Alexa::Skill"))
      
      expect(service).to receive(:warn)

      service.run
    end
  end
end