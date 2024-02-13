# Ralyxa

[![Build Status](https://travis-ci.org/sjmog/ralyxa.svg?branch=master)](https://travis-ci.org/sjmog/ralyxa)

A Ruby framework for interacting with Amazon Alexa. Designed to work with Sinatra, although can be used with a few other web frameworks.

An example application implementing the gem can be played with [here](https://github.com/sjmog/ralyxa_example).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ralyxa'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ralyxa

## Usage

### Getting Started

First, you've gotta pass the request from Sinatra to Ralyxa. Add a single `POST` route to your Sinatra application, with the following:

```ruby
require 'sinatra'
require 'ralyxa'

post '/' do
  Ralyxa::Skill.handle(request)
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

##### Playing audio with the `AudioPlayer` directive

###### Play

You can play an audio stream right away with:

```ruby
intent "PlayAudio" do
  audio_player.play(
    'https://s3.amazonaws.com/my-ssml-samples/Flourish.mp3',
    'flourish-token',
    speech: 'Playing Audio'
  )
end
```

###### Play Later (Enqueue)

You can queue a song to play next with:

```ruby
intent "PlayAudioLater" do
  audio_player.play_later(
    'https://s3.amazonaws.com/my-ssml-samples/Flourish.mp3',
    'flourish-token'
  )
end
```

###### Stop

You can stop playing with:

```ruby
intent "StopAudio" do
  audio_player.stop
end
```

###### Clear Queued

You can clear enqueued audio with:

```ruby
intent "ClearQueue" do
  audio_player.clear_queue
end
```

##### Reading the session user

You can read the session user's `userId` and `accessToken`, and check that the `accessToken` exists:

```ruby
request.user_id #=> returns the `userId` value from the request session
request.user_access_token # => returns the `accessToken` value from the request session
request.user_access_token_exists? # => true if the user has an access token, false if not
```

##### Reading the skill's locale

You can also read the skill's `locale`. A locale is basically a combination of a language and a location of your skill:

```ruby
request.locale #=> returns "en-GB", "it-IT", "ja-JP"...
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

##### Using SSML

You can use [Speech Synthesis Markup Language](https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/docs/speech-synthesis-markup-language-ssml-reference) to directly control Alexa's pronunciation:

```ruby
intent "SpellOut" do
  ask("<speak><say-as interpret-as='spell-out'>Hello World</say-as></speak>", ssml: true)
end
```

##### Using Cards

You can send cards to the Alexa app. Ralyxa will automatically figure out if you're trying to send a 'Simple' or 'Standard' card type:

```ruby
# Simple card
intent "SendSimpleCard" do
  simple_card = card("Hello World", "I'm alive!")
  ask("What do you think of the Simple card I just sent?", card: simple_card)
end

# Standard card
intent "SendStandardCard" do
  standard_card = card("Hello World", "I'm alive!", "http://placehold.it/720x480", "http://placehold.it/1200x800")
  
  ask("What do you think of the Standard card I just sent?", card: standard_card)
end
```

> Card images must be under 2MB and available at an SSL-enabled (HTTPS) endpoint.

##### Account Linking

You can ask Alexa to send a [`LinkAccount`](https://developer.amazon.com/blogs/post/Tx3CX1ETRZZ2NPC/Alexa-Account-Linking-5-Steps-to-Seamlessly-Link-Your-Alexa-Skill-with-Login-wit) card for the user to authenticate via OAuth:

```ruby
intent "SendAccountLinkingCard" do
  tell("Please authorize via the Alexa app.", card: link_account_card)
end
```

After completing authentication, the user's access token is available via `request.user_access_token`. You can check for its existence with `request.user_access_token_exists?`.

If, for example, you wanted to require authorization for an intent called `SecretIntent`:

```ruby
intent "SecretIntent" do
  return tell("Please authorize via the Alexa app", card: link_account_card) unless request.user_access_token_exists?
  ask("Welcome to the secret zone. What's next?")
end
```

## Ephemera

> Alexa says there's a problem if I just fail to reply to a prompt!

This is probably because your application is not handling the `SessionEndedRequest` intent. That's a built-in intent that kicks in after the user says 'exit', or nothing at all, in response to an ask. You'll probably see a warning in your server logs. To resolve it, implement the following intent:

```ruby
intent "SessionEndedRequest" do
  respond
end
```

> You can't actually respond to a `SessionEndedRequest`, but you might want to do some tidying in this action.


### I want to serve card images, audio stream etc. over HTTP not HTTPS

In some special cases, you may be allowed to serve content over HTTP instead of HTTPS. To allow this within Ralyxa, you need to set the `require_secure_urls` configuration option to false.

> **NOTE:** In order to use HTTP sources, you must be given special approval directly from Amazon. If you use HTTP sources without getting advanced approval, your skill will not work correctly.

```ruby
Ralyxa.configure do |config|
  config.require_secure_urls = false
end
```


## Testing
Part of Amazon's requirements for Alexa skills is that they have to ensure requests are sent from Amazon. This is done in a number of ways documented [here](https://developer.amazon.com/docs/custom-skills/host-a-custom-skill-as-a-web-service.html). This verification is built into Ralyxa and can cause issues when testing your skills with stubbed data.

### Disabling verification
Inside of your spec_helper files, include the following to disable verification:

#### RSpec
```ruby
require 'ralyxa'

RSpec.configure do |config|
  config.before :each do
    Ralyxa.configure do |config|
      config.validate_requests = false
    end
  end
end
```

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rspec` to run the tests. You can also run `irb` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sjmog/ralyxa. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

The main areas of focus are:

- Reprompts :construction:
- Dialogue :construction:
- Generators of built-in Intents e.g. `SessionEndedRequest`
- Automation with the `AVS` command line tool

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

