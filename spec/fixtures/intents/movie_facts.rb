require './lib/movie'

intent "MovieFacts" do
  movie = Movie.find(request.slot_value("Movie"))

  ask(movie.plot_synopsis, session_attributes: { movieTitle: movie.title })
end