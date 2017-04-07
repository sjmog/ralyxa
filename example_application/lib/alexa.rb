require_relative './alexa/handlers'

module Alexa
  class Skill
    def self.register_intents
      Dir.glob("intents/*.rb").each { |intent| register(intent) }
    end

    def self.register(intent)
      Alexa::Handlers.class_eval File.open(File.expand_path(intent)).read
    end
  end
end

Alexa::Skill.register_intents