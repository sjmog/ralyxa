require 'ralyxa/response_entities/card'

RSpec.describe Ralyxa::ResponseEntities::Card do
  subject(:card) { described_class.as_hash }

  describe '.as_hash' do
    it 'generates a Simple card given only a title and body' do
      expected_result = { 
        type: "Simple", 
        title: "Hello Card", 
        content: "Hello, string!" 
      }

      simple_card = described_class.as_hash("Hello Card", "Hello, string!")
      expect(simple_card).to eq expected_result
    end

    it 'generates a Standard card given title, body, and an image URL' do
      expected_result = {
        type: "Standard", 
        title: "Hello Card", 
        text: "Hello, string!", 
        image: { 
          smallImageUrl: "https://example.com/image.jpg",
          largeImageUrl: "https://example.com/image.jpg"
        }
      }

      standard_card = described_class.as_hash("Hello Card", "Hello, string!", "https://example.com/image.jpg")
      expect(standard_card).to eq expected_result
    end

    it 'raises an error if the card is given an image that does not start with https://' do
      expect { described_class.as_hash("Hello Card", "Hello, string!", "http://image.url") }.to raise_error UnsecureUrlError
    end
  end

  describe '.link_account' do
    it 'generates a LinkAccount card' do
      expected_result = {
        type: "LinkAccount"
      }

      link_account_card = described_class.link_account
      expect(link_account_card).to eq expected_result
    end
  end
end