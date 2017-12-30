require 'ralyxa/version'
require 'ralyxa/configuration'
require 'ralyxa/register_intents'
require 'ralyxa/skill'

module Ralyxa
  class << self
    attr_accessor :configuration

    def configure
      yield configuration if block_given?
    end

    def method_missing(m, *args, &block)
      if configuration.respond_to?(m)
        configuration.send(m, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(m, include_private = false)
      configuration.respond_to?(m) || super
    end

    private

    def setup_configuration
      @configuration = Ralyxa::Configuration.new
    end
  end

  setup_configuration
end

Ralyxa::RegisterIntents.run
