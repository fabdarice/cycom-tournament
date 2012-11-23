class Round < ActiveRecord::Base
  belongs_to :game

  # state values
  SCHEDULED = I18n.translate("state.scheduled")
  RUNNING = I18n.translate("state.running")
  DONE = I18n.translate("state.done")
  DRAW = I18n.translate("state.draw")
  WIN_FIRST = I18n.translate("state.win_first")
  WIN_SECOND = I18n.translate("state.win_second")
  STATES = [ SCHEDULED, RUNNING, DONE, DRAW, WIN_FIRST, WIN_SECOND ]

  def update_state
    if state == DONE
      if first_score > second_score
        update_attribute(:state, WIN_FIRST)
      elsif second_score > first_score
        update_attribute(:state, WIN_SECOND)
      else
        update_attribute(:state, DRAW)
      end
      game.end_of_round(self)
    elsif state == DRAW or state == WIN_FIRST or state == WIN_SECOND
      game.end_of_round(self)
    end
  end
  
end
