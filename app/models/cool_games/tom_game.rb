module CoolGames
  class TomGame < ActiveRecord::Base

    set_table_name CoolGames::Engine.table_prefix + "tom_games"

  end
end
