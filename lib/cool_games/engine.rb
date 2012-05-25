module CoolGames
  class Engine < ::Rails::Engine
    isolate_namespace CoolGames

    # This makes it possible to refer routes like cool_games.games_path
    engine_name 'cool_games'

  end
end
