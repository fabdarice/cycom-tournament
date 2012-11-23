class Ranking < ActiveRecord::Base
  belongs_to :tournament
  has_many :groups

  after_create :create_groups

  validates_presence_of :tournament_id, :round, :win_points,
  :draw_points, :lose_points, :groups_number, :qualified, :games_number,
  :state, :best_of
  validates_numericality_of :win_points, :draw_points, :lose_points,
  :groups_number, :qualified, :games_number, :only_integer => true
  validates_numericality_of :best_of, :odd => true

  def add_participant(participant_id)
    @current_group ||= 0
    groups[@current_group].add_participant(participant_id)
    @current_group = (@current_group + 1) % groups_number
  end

  def qualified_participants
    qualified_by_group = []
    qualified_participants = []
    qualified_per_group = qualified / groups_number
    groups.each do |group|
      qualified_by_group << group.ranking_lines.by_order.limit(qualified_per_group + 1).all
    end
    0.upto(qualified_per_group - 1) do |pos|
      0.upto(groups_number - 1) do |group|
        qualified_participants << qualified_by_group[group][pos].participant_id
      end
    end
  
    unless qualified % groups_number == 0
      second_chance = []
      0.upto(groups_number - 1) do |group|
        second_chance << qualified[group][qualified_per_group] if qualified[group][qualified_per_group]
      end
      sorted_second_chance = sort_ranking_lines(second_chance.dup)
      sorted_second_chance = sorted_second_chance.slice(0, qualified % groups_number)
      second_chance.each do |line|
        qualified_participants << line.participant_id if sorted_second_chance.include?(line)
      end
    end
    qualified_participants
  end

  private

  def create_groups
    1.upto(groups_number) do |n|
      groups.create(:name => n.to_s)
    end
  end

  def sort_ranking_lines(ranking_lines)
    ranking_lines.sort do |r1,r2|
      if r1.points > r2.points
        -1
      else
        if r1.diff > r2.diff
          -1
        else
          if r1.plus > r2.plus
            -1
          else
            1
          end
        end
      end
    end
  end
end
