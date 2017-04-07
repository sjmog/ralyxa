require 'movie'

RSpec.describe Movie do
  describe '.find' do
    it 'delegates finding a movie to an Imdb client search' do
      client = double("Imdb::Search")
      expect(client).to receive_message_chain(:new, :movies, :first)

      described_class.find("Some Movie Title", client)
    end
  end

  describe '#plot_synopsis' do
    it 'returnst the ploy synopsis of the underlying record' do
      imdb_record = double("Imdb::Movie", plot_synopsis: "This Movie is great!")

      expect(described_class.new(imdb_record).plot_synopsis).to eq "This Movie is great!"
    end
  end

  describe '#cast_list' do
    it 'returns a human-readable string of cast members' do
      imdb_record = double("Imdb::Movie", title: "Movie", cast_members: ["Famous star 1", "Famous star 2"])

      expect(described_class.new(imdb_record).cast_members).to eq "Movie starred Famous star 1, Famous star 2"
    end
  end

  describe '#directors' do
    it 'returns a human-readable string of director names' do
      imdb_record = double("Imdb::Movie", title: "Movie", director: ["Famous director"])

      expect(described_class.new(imdb_record).directors).to eq "Movie was directed by Famous director"
    end
  end
end