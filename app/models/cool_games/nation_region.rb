module CoolGames
  class NationRegion < ActiveRecord::Base

    set_table_name CoolGames::Engine.table_prefix + "nation_regions"

  end
end
