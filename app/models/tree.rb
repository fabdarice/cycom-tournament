class Tree < ActiveRecord::Base
  belongs_to :tournament
  has_many :tree_positions

  after_create :create_tree_positions

  # TYPE ENUMERATION
  SINGLE = "single"
  DOUBLE = "double"
  TYPES = [ SINGLE, DOUBLE ]

  # STATE ENUMERATION
  SCHEDULED = "programme"
  RUNNING = "en cours"
  DONE = "terminé"
  STATES = [ SCHEDULED, RUNNING, DONE ]

  # Create all the TreePosition for this tree
  # Allow the whole tree to be drawn empty at the beginning
  def create_tree_positions
    # Get the number of qualified participants from the tournament
    if tournament.rankings.empty?
      participants_number = tournament.max_participants
    else
      # Or from the number of qualified from last ranking
      participants_number = tournament.rankings[tournament.rankings.size - 1].qualified
    end

    special = false
    next_depth = participants_number
    special_falling = false
    (participants_number * 2 - 1).downto(1) do |pos|
      tree_positions.create(:position => pos, :special => special)
      if tree_type == DOUBLE
        if pos.even?
          tree_positions.create(:position => -pos, :special => false)
          tree_positions.create(:position => -pos, :special => true) if special_falling
        elsif special_falling and pos != 1
          tree_positions.create(:position => -pos, :special => true)
        end
      end
      if pos == next_depth
        special_falling = true
        special = !special
        next_depth /= 2
      end
    end
  end

  def set_participants(participants)
    pos = participants.size
    0.upto(participants.size / 2 - 1) do |n|
      first = tree_positions.find_by_position(pos)
      first.update_attributes(:participant_id => participants[n],
                              :participant_type => tournament.participants_type)

      second = tree_positions.find_by_position(pos + 1)
      second.update_attributes(:participant_id => participants[participants.size - n - 1],
                               :participant_type => tournament.participants_type)

      pos = pos + 2
    end
  end
end
