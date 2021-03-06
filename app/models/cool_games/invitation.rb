module CoolGames
  class Invitation < ActiveRecord::Base
    include AASM

    set_table_name "cg_invitations"

    belongs_to :inviter, :class_name => 'CoolGames::Player', :foreign_key => 'inviter_id'
    belongs_to :game

    attr_accessor :invitee

    INVITER_PLAY_FIRST = 1
    INVITEE_PLAY_FIRST = 2

    default_scope :order => "created_at DESC"

    scope :active, lambda {
      {:conditions => ["state not in ('accepted', 'rejected', 'canceled', 'expired')"]}
    }

    scope :by_me, lambda { |player|
      {:conditions => ["inviter_id = ?", player.id]}
    }

    scope :to_me, lambda { |player|
      {:conditions => ["invitees like ?", "%\"#{player.id}\":%"]}
    }

    aasm_column :state

    aasm_initial_state :new

    aasm_state :new
    aasm_state :accepted, :enter => :create_game
    aasm_state :rejected, :enter => :send_reject_message
    #aasm_state :changed_by_inviter
    #aasm_state :changed_by_invitee
    aasm_state :canceled
    aasm_state :expired

    aasm_event :accept do |*args|
      transitions :to => :accepted, :from => [:new]
    end

    aasm_event :reject do
      transitions :to => :rejected, :from => [:new]
    end

    aasm_event :cancel do
      transitions :to => :canceled, :from => [:new]
    end

    def self.parse_invitees invitees
      unrecognized = []
      result = {}
      invitees.split(/[ ,]+/).each do |invitee|
        invitee.strip!

        player = Player.find_by_name invitee
        if player
          result[player.id] = invitee
        else
          unrecognized << invitee
        end
      end
      return result, unrecognized
    end

    def self.handicap_str handicap
      I18n.t("invitations.handicap_#{handicap}")
    end

    after_create do
      send_invitation_message
    end

    def invitees_str
      unless invitees.blank?
        JSON.parse(invitees).values.join(", ")
      end
    end

    def game_type_str
      case game_type
        when Game::DAOQI then I18n.t('games.daoqi_label')
        else I18n.t('games.weiqi_label')
      end
    end

    def start_side_str
      case start_side
        when INVITER_PLAY_FIRST then I18n.t('invitations.inviter_start')
        when INVITEE_PLAY_FIRST then I18n.t('invitations.invitee_start')
        else I18n.t('invitations.random_start')
      end
    end

    def handicap_str
      self.class.handicap_str(handicap.to_i)
    end

    def created_by_me? player
      player.id == self.inviter_id
    end

    def for_me? player
      JSON.parse(invitees)[player.id.to_s]
    end

    def create_game
      game = Game.new
      game.state = 'new'
      game.gaming_platform_id = GamingPlatform.gocool.id
      game.game_type = game_type
      game.board_size = 19
      game.rule = rule
      game.handicap = handicap
      game.komi = komi
      game.name = note
      game.moves = 0
      game.start_side = handicap.to_i < 2 ? Game::BLACK : Game::WHITE
      game.for_rating = for_rating
      #game.place = "#{GamingPlatform.gocool.name} #{GamingPlatform.gocool.url}"

      PairStat.find_or_create(inviter.id, invitee.id)
      PairStat.find_or_create(invitee.id, inviter.id)

      if start_side == INVITER_PLAY_FIRST or (start_side != INVITEE_PLAY_FIRST and rand(1000)%2 == 0) # inviter plays first
        game.black_id = inviter.id
        game.black_name = inviter.name
        game.black_rank = inviter.rank
        game.white_id = invitee.id
        game.white_name = invitee.name
        game.white_rank = invitee.rank
      else # invitee plays first
        game.black_id = invitee.id
        game.black_name = invitee.name
        game.black_rank = invitee.rank
        game.white_id = inviter.id
        game.white_name = inviter.name
        game.white_rank = inviter.rank
      end
      game.start
      game.save!

      self.game_id = game.id
      self.save!

      GameDetail.create!(:game_id => game.id, :whose_turn => game.start_side, :formatted_moves => "")

      #Discuz::PrivateMessage.send_message invitee, inviter, "",
      #                                    I18n.t('invitations.accept_invitation_body').sub('USERNAME', invitee.name).sub("GAME_URL", "#{ENV['BASE_URL']}/app/games/#{game.id}")

      game
    end

    def send_reject_message
      #invitee = current_player
      #Discuz::PrivateMessage.send_message invitee, inviter, "",
      #                                    I18n.t('invitations.reject_invitation_body').sub('USERNAME', invitee.name).sub("INVITATION_URL", "#{ENV['BASE_URL']}/app/invitations/#{id}")
    end

    def send_invitation_message
      #JSON.parse(invitees).keys.each do |invitee_id|
      #  invitee = Player.find invitee_id
      #  Discuz::PrivateMessage.send_message inviter, invitee, "",
      #                                      I18n.t('invitations.invitation_body').sub('USERNAME', inviter.name).
      #                                              gsub("INVITATION_URL", "#{ENV['BASE_URL']}/app/invitations/#{id}").
      #                                              sub('GAME_TYPE', game_type_str)
      #end
    end
  end
end
