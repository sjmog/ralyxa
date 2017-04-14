# Ralyxa

A Ruby framework for interacting with Amazon Alexa. Designed to work with Sinatra, although can be used with a few other web frameworks.

An example application that fetches facts about movies is in the `example_application` directory.

### Getting Started

First, you've gotta pass the request from Sinatra to Ralyxa. Add a single `POST` route to your Sinatra application, with the following:

```ruby
require 'sinatra'
require './lib/alexa'

post '/' do
  Alexa::Handlers.handle(request)
end
```

Second, you've gotta define your intents. To define a new intent, create a directory called 'intents'. Inside there, create a `.rb` file:

```ruby
intent "IntentName" do
  # Whatever logic you want to do
  # fetching something for the response
  # persisting something etc
  # this is plain Ruby, so go wild

  respond("This is what Alexa will say to the user")
end
```

Third, define your Intent and Utterance on the Alexa Developer portal. You can then test your application in the Service Simulator (either by pushing the Sinatra app somewhere with HTTPS or, more easily, using ngrok to tunnel the application).

### Being more pro

##### `ask` and `tell`

There are two kinds of responses you can send to Alexa: `ask`s and `tell`s. An `ask` should ask the user a question, and expect them to reply. A `tell` should end the conversation.

When defining intents, you can use the `#ask` and `#tell` methods in place of `#respond` to keep the session open, or close it:

```ruby
intent "AskMoreQuestions" do
  ask("What next?")
end
```

```ruby
intent "SayGoodbye" do
  tell("Goodbye.")
end
```

> A `tell` is basically a `#respond` with `end_session: true`. You can use that instead if you prefer.

##### Reading and setting session attributes

You can persist data to an Alexa session:

```ruby
intent "PersistThis" do
  ask("Got it. What now?", session_attributes: { persist: "this" })
end
```

And, subsequently, read it:

```ruby
intent "ReadFromSession" do
  persisted_data = request.session_attribute("persist")
  ask("You persisted: #{ persisted_data }")
end
```

> Go check out the `Alexa::Request` object to see what else you can do with the `request`.

##### Ending sessions

If, for some reason, you want to end a session in some other way than with a `tell`, you can:

```ruby
intent "ConfuseTheUser" do
  respond("This actually ends the session.", end_session: true)
end
```

##### Starting over

You can start conversations over, which clears the session attributes:

```ruby
intent "AMAZON.StartOverIntent" do
  ask("Starting over. What next?", start_over: true)
end
```

##### TODO

- Cards :construction:
- Account linking :construction:
- Audio directives :construction:
- SSML :construction:
- Reprompts :construction:
- Generator?