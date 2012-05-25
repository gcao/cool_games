class AddData < ActiveRecord::Migration
  def up
    #china = NationRegion.create!(:name => 'China')
    #usa   = NationRegion.create!(:name => 'USA')
    #japan = NationRegion.create!(:name => 'Japan')
    #korea = NationRegion.create!(:name => 'Korea')
    #
    #GamingPlatform.create!(:nation_region_id => usa.id, :name => 'KGS',
    #                       :description => 'The KGS Go Server', :url => 'www.gokgs.com')
    #GamingPlatform.create!(:nation_region_id => usa.id, :name => 'DGS',
    #                       :description => 'The Dragon Go Server',
    #                       :url => 'www.dragongoserver.net', :is_turn_based => true)
    #GamingPlatform.create!(:nation_region_id => china.id, :name => 'TOM',
    #                       :description => 'TOM围棋网',
    #                       :url => 'weiqi.sports.tom.com', :is_turn_based => false)
    #GamingPlatform.create!(:nation_region_id => japan.id, :name => 'IGS',
    #                       :description => 'the Internet Go Server',
    #                       :url => 'http://www.pandanet.co.jp/English/', :is_turn_based => false)
    #GamingPlatform.create!(:nation_region_id => china.id, :name => '弈城',
    #                       :description => '弈城围棋网',
    #                       :url => 'http://www.eweiqi.com', :is_turn_based => false)
    #GamingPlatform.create!(:nation_region_id => china.id, :name => '新浪',
    #                       :description => '新浪围棋网',
    #                       :url => 'http://duiyi.sina.com.cn', :is_turn_based => false)
  end

  def down
  end
end
