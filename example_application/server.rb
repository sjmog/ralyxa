require 'sinatra'
require './lib/alexa'

post '/' do
  Alexa::Handlers.handle(request)
end