module CoolGames
  class PlayerStat < ActiveRecord::Base
    include AbstractPlayerStat

    set_table_name CoolGames::Engine.table_prefix + "player_stats"
  end
end
