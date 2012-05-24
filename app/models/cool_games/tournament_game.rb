module CoolGames
  class TournamentGame < ActiveRecord::Base

    set_table_name CoolGames::Engine.table_prefix + "tournament_games"

  end
end
