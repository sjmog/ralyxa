module Ralyxa
  module ResponseEntities
    module Directives
      class AudioPlayer
        class Play
          CLEAR_ENQUEUE    = 'CLEAR_ENQUEUE'.freeze
          ENQUEUE          = 'ENQUEUE'.freeze
          REPLACE_ALL      = 'REPLACE_ALL'.freeze
          REPLACE_ENQUEUED = 'REPLACE_ENQUEUED'.freeze

          def initialize(stream, behaviour = Ralyxa::ResponseEntities::Directives::AudioPlayer::Play::REPLACE_ALL)
            @stream    = stream
            @behaviour = behaviour
          end

          def to_h
            {}.tap do |audio_player|
              audio_player['type'] = 'AudioPlayer.Play'
              audio_player['playBehavior'] = @behaviour

              audio_player['audioItem'] = Ralyxa::ResponseEntities::Directives::Audio::AudioItem.new(@stream).to_h
            end
          end

          def self.as_hash(stream, behaviour = nil)
            new(stream, behaviour).to_h
          end
        end
      end
    end
  end
end
