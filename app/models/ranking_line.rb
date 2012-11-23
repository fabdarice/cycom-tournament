class RankingLine < ActiveRecord::Base
  belongs_to :group
  belongs_to :user, :foreign_key => "participant_id"
  belongs_to :team, :foreign_key => "participant_id"

  scope :by_points, order('points DESC')
  scope :by_diff, order('diff DESC')
  scope :by_plus, order('plus DESC')
  scope :by_order, order('points DESC, diff DESC, plus DESC')

  def participant
    if is_individual?
      user.nickname
    else
      team.name
    end
  end

  def add_draw(p, m)
    update_attributes({ :points => self.points + group.ranking.draw_points,
                        :draw => self.draw + 1,
                        :plus => self.plus + p,
                        :minus => self.minus + m,
                        :diff => self.diff + p - m
                      })
  end

  def add_win(p, m)
    update_attributes({ :points => self.points + group.ranking.win_points,
                        :win => self.win + 1,
                        :plus => self.plus + p,
                        :minus => self.minus + m,
                        :diff => self.diff + p - m
                      })
  end

  def add_lose(p, m)
    update_attributes({ :points => self.points + group.ranking.lose_points,
                        :lose => self.lose + 1,
                        :plus => self.plus + p,
                        :minus => self.minus + m,
                        :diff => self.diff + p - m
                      })
  end

  private

  def is_individual?
    participant_type == Tournament::PARTICIPANT_TYPE_SINGLE
  end

  def is_in_team?
    participant_type == Tournament::PARTICIPANT_TYPE_TEAM
  end
end
