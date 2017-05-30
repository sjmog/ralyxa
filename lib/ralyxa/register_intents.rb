require_relative './skill'

module Ralyxa
  class RegisterIntents
    DEFAULT_INTENTS_DIRECTORY = "./intents".freeze

    def initialize(intents_directory, alexa_skill_class)
      @intents_directory = intents_directory
      @alexa_skill_class = alexa_skill_class
    end

    def self.run(intents_directory = DEFAULT_INTENTS_DIRECTORY, alexa_skill_class = Ralyxa::Skill)
      new(intents_directory, alexa_skill_class).run
    end

    def run
      warn NO_INTENT_DECLARATIONS_FOUND if intent_declarations.empty?

      intent_declarations.each do |intent_declaration|
        alexa_skill_class.class_eval intent_declaration
      end
    end

    private
    attr_reader :intents_directory, :alexa_skill_class

    def intent_declarations
      @intent_declarations ||=
      Dir.glob("#{ intents_directory }/*.rb")
        .map { |relative_path| File.expand_path(relative_path) }
        .map { |intent_declaration_path| File.open(intent_declaration_path).read }
    end

    NO_INTENT_DECLARATIONS_FOUND = <<~HEREDOC
    \e[33m
    WARNING: You haven't defined any intent declarations. 

    Please define intent declarations inside a directory called 'intents', 
    on the same directory level as the runfile for your server application.
    \e[0m
    HEREDOC
  end
end