module CoolGames
  class TournamentPlayer < ActiveRecord::Base

    set_table_name CoolGames::Engine.table_prefix + "tournament_players"

  end
end
