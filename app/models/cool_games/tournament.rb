module CoolGames
  class Tournament < ActiveRecord::Base

    set_table_name CoolGames::Engine.table_prefix + "tournaments"

  end
end
