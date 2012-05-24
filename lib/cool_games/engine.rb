module CoolGames
  class Engine < ::Rails::Engine
    isolate_namespace CoolGames

    # This makes it possible to refer routes like cool_games.games_path
    engine_name 'cool_games'

    cattr_accessor :table_prefix

    self.table_prefix = "cg_"
  end
end
