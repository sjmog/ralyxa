module Ralyxa
  module ResponseEntities
    module Directives
      class AudioPlayer
        class ClearQueue
          CLEAR_ENQUEUED = 'CLEAR_ENQUEUED'.freeze
          CLEAR_ALL = 'CLEAR_ALL'.freeze

          def initialize(behaviour = Ralyxa::ResponseEntities::Directives::AudioPlayer::ClearQueue::CLEAR_ENQUEUED)
            @behaviour = behaviour
          end

          def to_h
            {}.tap do |audio_player|
              audio_player['type'] = 'AudioPlayer.ClearQueue'
              audio_player['clearBehavior'] = @behaviour
            end
          end

          def self.as_hash(behaviour = Ralyxa::ResponseEntities::Directives::AudioPlayer::ClearQueue::CLEAR_ENQUEUED)
            new(behaviour).to_h
          end
        end
      end
    end
  end
end
