class TreePosition < ActiveRecord::Base
  belongs_to :tree
  belongs_to :user, :foreign_key => :participant_id
  belongs_to :team, :foreign_key => :participant_id
  has_one :game, :as => :playable

  scope :by_position, order("position DESC")
  scope :by_nposition, order("position ASC")
  scope :winner, where("position > 0")
  scope :loser, where("position < 0")

  after_update :create_game

  def participant
    if is_individual?
      user.nickname
    else
      team.name
    end
  end

  def end_of_game(game)
    unless position == 1
      if game.state == Game::WIN_FIRST
        w = self
        l = tree.tree_positions.find_by_position(opponent_position)
      else
        w = tree.tree_positions.find_by_position(opponent_position)
        l = self
      end

      if position > 0
        t = tree.tree_positions.find_by_position(self.position / 2)
        t.update_attributes(:participant_id => w.participant_id,
                            :participant_type => w.participant_type)
      end

      if tree.tree_type == Tree::DOUBLE
        if self.position < 0
          win_pos = (self.special) ? self.position : (self.position - 2) / 2
          t = tree.tree_positions.where([ "position = ? AND special = ?",
                                                        win_pos, !self.special]).first
          t.update_attributes(:participant_id => w.participant_id, :participant_type => w.participant_type)
        else
          tmp = tree.tree_positions.loser.by_nposition.first
          first_loser = -((Math.log(tmp.position.abs)/Math.log(2)).floor ** 2)
          t = tree.tree_positions.where([ "position = ? AND special = ?",
                                                        -self.position, -self.position > first_loser]).first
          t.update_attributes(:participant_id => l.participant_id,
                              :participant_type => l.participant_type)
        end
      end
    end
  end

  private

  def is_individual?
    participant_type == Tournament::PARTICIPANT_TYPE_SINGLE
  end

  def is_in_team?
    participant_type == Tournament::PARTICIPANT_TYPE_TEAM
  end

  def create_game
    if participant_id
      if position == 1
        opponent = tree.tree_positions.where("position = -2 AND special = false").first
      elsif position == -2 and special == false
        opponent = tree.tree_positions.where("position = 1").first
      else
        opponent = tree.tree_positions.where([ "position = ? AND special = ?",
                                                             opponent_position, special]).first
      end
      if opponent and opponent.participant_id
        if ((position > 0 or special) and (position % 2) != 0) or
            ((position < 0) and (!special) and (((position / 2) % 2) != 0))
          Game.create(:first_participant_id => opponent.participant_id,
                      :second_participant_id => participant_id,
                      :participant_type => participant_type,
                      :best_of => self.tree.best_of,
                      :playable_type => "TreePosition",
                      :playable_id => opponent.id)
        else
          Game.create(:first_participant_id => participant_id,
                      :second_participant_id => opponent.participant_id,
                      :participant_type => participant_type,
                      :best_of => self.tree.best_of,
                      :playable_type => "TreePosition",
                      :playable_id => id)
        end
      end
    end
  end

  def opponent_position
    if position > 0
      (position % 2) == 0 ? position + 1 : position - 1
    else
      if special
        (position % 2) == 0 ? position - 1 : position + 1
      else
        ((position / 2) % 2) == 0 ? position - 2 : position + 2
      end
    end
  end
end
