require 'number_fact'

RSpec.describe NumberFact do
  describe '#text' do
    it 'gives the fact for a given number and fact type as plain text' do
      number_fact_text = "3 is the number of spatial dimensions we perceive our universe to have."
      client = double("Net::HTTP", get: number_fact_text)
      number_fact = described_class.new("3", "trivia", client)

      expect(number_fact.text).to eq number_fact_text
    end
  end

  describe '.build' do
    it 'builds a number fact using an Alexa Request' do
      alexa_request = double("Alexa::Request")
      allow(alexa_request).to receive(:slot_value).with("Number").and_return "3"
      allow(alexa_request).to receive(:slot_value).with("FactType").and_return "trivia"

      expect(described_class).to receive(:new).with("3", "trivia")

      described_class.build(alexa_request)
    end
  end
end