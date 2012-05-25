module CoolGames
  class PlayerStat < ActiveRecord::Base
    include AbstractPlayerStat

    set_table_name "player_stats"
  end
end
