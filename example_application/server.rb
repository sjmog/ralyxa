require 'sinatra'
require './lib/alexa'

post '/' do
  Alexa::Skill.handle(request)
end