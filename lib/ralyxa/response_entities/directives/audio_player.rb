require_relative './audio_player/clear_queue'
require_relative './audio_player/play'
require_relative './audio_player/stop'

module Ralyxa
  module ResponseEntities
    module Directives
      class AudioPlayer
        class << self
          def play(url, token, speech: nil, card: nil, offset_in_milliseconds: 0, expected_previous_token: nil, behaviour: Ralyxa::ResponseEntities::Directives::AudioPlayer::Play::REPLACE_ALL, audio_player_class: Ralyxa::ResponseEntities::Directives::AudioPlayer::Play, response_builder: Ralyxa::ResponseBuilder)
            directive = audio_player_class.as_hash(Ralyxa::ResponseEntities::Directives::Audio::Stream.new(url, token, offset_in_milliseconds, expected_previous_token), behaviour)

            response_builder.build(build_options(directive, speech, card))
          end

          def play_later(url, token, speech: nil, card: nil, offset_in_milliseconds: 0, expected_previous_token: nil, behaviour: Ralyxa::ResponseEntities::Directives::AudioPlayer::Play::REPLACE_ENQUEUED, audio_player_class: Ralyxa::ResponseEntities::Directives::AudioPlayer::Play, response_builder: Ralyxa::ResponseBuilder)
            play(url, token, speech: speech, card: card, offset_in_milliseconds: offset_in_milliseconds, expected_previous_token: expected_previous_token, behaviour: behaviour, audio_player_class: audio_player_class, response_builder: response_builder)
          end

          def stop(speech: nil, card: nil, audio_player_class: Ralyxa::ResponseEntities::Directives::AudioPlayer::Stop, response_builder: Ralyxa::ResponseBuilder)
            directive = audio_player_class.as_hash

            response_builder.build(build_options(directive, speech, card))
          end

          def clear_queue(speech: nil, card: nil, behaviour: Ralyxa::ResponseEntities::Directives::AudioPlayer::ClearQueue::CLEAR_ALL, audio_player_class: Ralyxa::ResponseEntities::Directives::AudioPlayer::ClearQueue, response_builder: Ralyxa::ResponseBuilder)
            directive = audio_player_class.as_hash(behaviour)

            response_builder.build(build_options(directive, speech, card))
          end

          private

          def build_options(directive, speech, card)
            {}.tap do |option|
              option[:directives] = [directive]
              option[:end_session] = false
              option[:response_text] = speech if speech
              option[:card] = card if card
            end
          end
        end
      end
    end
  end
end
