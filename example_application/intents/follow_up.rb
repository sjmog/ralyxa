require './lib/movie'

intent "FollowUp" do
  movie = Movie.find(request.session_attribute("movieTitle"))

  response_text = movie.directors if request.slot_value("Role") == "directed"
  response_text = movie.cast_members if request.slot_value("Role") == "starred in"
  response_text += ". What else would you like to know?"

  ask(response_text, session_attributes: { movieTitle: movie.title })
end