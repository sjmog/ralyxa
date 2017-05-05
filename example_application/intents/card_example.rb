intent "SendCatPic" do
  card = card("Isn't he a cutie?", "Check out this close tiger relative.", "http://placekitten.com/200/300")
  ask("I've sent a cat picture to your Alexa app. What do you think?", card: card)
end