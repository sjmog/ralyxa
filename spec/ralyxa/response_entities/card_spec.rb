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

    it 'generates a Standard card given title, body, and an image hash' do
      expected_result = {
        type: "Standard", 
        title: "Hello Card", 
        text: "Hello, string!", 
        image: { 
          smallImageUrl: "https://image.url",
          largeImageUrl: "https://large.image.url"
        }
      }

      standard_card = described_class.as_hash("Hello Card", "Hello, string!", "https://image.url", "https://large.image.url")
      expect(standard_card).to eq expected_result
    end

    it 'raises an error if the card is given an image that does not start with https://' do
      Ralyxa.require_secure_urls = true

      expect { described_class.as_hash("Hello Card", "Hello, string!", "http://image.url", "http://large.image.url") }.to raise_error Ralyxa::UnsecureUrlError
    end

    context 'with an incomplete image hash' do
      it 'generates the expected standard card with a small and large image based on the small image' do
        expected_result = {
            type: "Standard",
            title: "Hello Card",
            text: "Hello, string!",
            image: {
                smallImageUrl: "https://image.url",
                largeImageUrl: "https://image.url"
            }
        }

        standard_card = described_class.as_hash("Hello Card", "Hello, string!", "https://image.url")
        expect(standard_card).to eq expected_result
      end

      it 'generates the expected standard card with a small and large image based on the large image' do
        expected_result = {
            type: "Standard",
            title: "Hello Card",
            text: "Hello, string!",
            image: {
                smallImageUrl: "https://large.image.url",
                largeImageUrl: "https://large.image.url"
            }
        }

        standard_card = described_class.as_hash("Hello Card", "Hello, string!", nil, "https://large.image.url")
        expect(standard_card).to eq expected_result
      end
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