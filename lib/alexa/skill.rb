require './lib/alexa/handlers'

module Alexa
  class Skill
    INTENTS_DIRECTORY = "./intents".freeze
    NO_INTENTS_DEFINITIONS_FOUND = <<~HEREDOC
    \e[33m
    WARNING: You haven't defined any intents. 

    Please define intents inside a directory called 'intents', 
    on the same directory level as the runfile for your server application.
    \e[0m
    HEREDOC

    def self.register_intents
      intent_definition_files = Dir.glob("#{ INTENTS_DIRECTORY }/*.rb")
      warn NO_INTENTS_DEFINITIONS_FOUND if intent_definition_files.empty?
      
      intent_definition_files.each { |intent_definition_file| register(intent_definition_file) }
    end

    def self.register(intent_definition_file)
      intent_definition = File.open(File.expand_path(intent_definition_file)).read
      Alexa::Handlers.class_eval intent_definition
    end
  end
end