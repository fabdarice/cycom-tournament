class Game < ActiveRecord::Base
  belongs_to :playable, :polymorphic => true
  belongs_to :first_user, :class_name => "User", :foreign_key => "first_participant_id"
  belongs_to :second_user, :class_name => "User", :foreign_key => "second_participant_id"
  belongs_to :first_membership, :class_name => "Membership", :foreign_key => "first_participant_id"
  belongs_to :second_membership, :class_name => "Membership", :foreign_key => "second_participant_id"
  has_many :rounds

  after_create :new_round

  # state values
  SCHEDULED = "a jouer"
  RUNNING = "en cours"
  DRAW = "match nul"
  WIN_FIRST = "win_first"
  WIN_SECOND = "win_second"
  STATES = [ SCHEDULED, RUNNING, DRAW, WIN_FIRST, WIN_SECOND ]

  def new_round
    rounds.create(:game_round => rounds.size + 1,
                  :first_score => 0,
                  :second_score => 0,
                  :state => Round::SCHEDULED)
  end

  def is_not_done?
    state != DRAW and state != WIN_FIRST and state != WIN_SECOND
  end

  # Callback on end of round
  def end_of_round(round)
    if is_not_done? and round.game_round == rounds.size
      win_first = rounds.where(:state => Round::WIN_FIRST).all.size
      if win_first > (best_of / 2)
        update_attribute(:state, WIN_FIRST)
        playable.end_of_game(self)
      else
        win_second = rounds.where(:state => Round::WIN_SECOND).all.size
        if win_second > (best_of / 2)
          update_attribute(:state, WIN_SECOND)
          playable.end_of_game(self)
        else
          if round.game_round == best_of
            update_attribute(:state, DRAW)
            playable.end_of_game(self)
          else
            new_round
          end
        end
      end
    end
  end

  def first_plus
    f = 0
    rounds.each do |round|
      f += round.first_score
    end
    f
  end

  def second_plus
    f = 0
    rounds.each do |round|
      f += round.second_score
    end
    f
  end

  def first_minus
    second_plus
  end

  def second_minus
    first_plus
  end

  def first_participant
    if is_individual?
      first_user.nickname
    else
      first_membership.user.nickname
    end
  end

  def second_participant
    if is_individual?
      second_user.nickname
    else
      second_membership.user.nickname
    end
  end

  private

  def is_individual?
    participant_type == Tournament::PARTICIPANT_TYPE_SINGLE
  end

  def is_in_team?
    participant_type == Tournament::PARTICIPANT_TYPE_TEAM
  end
end
