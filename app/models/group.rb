class Group < ActiveRecord::Base
  belongs_to :ranking
  has_many :ranking_lines
  has_many :games, :as => :playable

  def add_participant(participant_id)
      line = RankingLine.new
      line.group_id = id
      line.participant_id = participant_id
      line.participant_type = ranking.tournament.participants_type
      line.points = 0
      line.win = 0
      line.draw = 0
      line.lose = 0
      line.plus = 0
      line.minus = 0
      line.diff = 0
      line.save
    end

  # Create a coherent list of games
  # Each participant has to play 'number' games
  #
  # Algorithm: http://en.wikipedia.org/wiki/Round-robin_tournament
  def create_games(number)
      participants = build_participants()
      missing_games = []
      first_is_home = false
      1.upto(number) do |n|
        first_is_home = !first_is_home
        # Generate the games
        0.upto(participants.size / 2 - 1) do |i|
          if participants[i] != 0 and participants[participants.size - 1 - i] != 0
              create_game(participants[i], participants[participants.size - 1 - i],
                          first_is_home)
          else
            # We add the non playing participant to the missing games array
            missing_games << participants[(participants[i] == 0) ? participants.size - 1 - i : i]
          end
        end
        participants = rotate_participants(participants)
  
        # We have finished one turn, we have to inverse the field advantage
        first_is_home = !first_is_home if (n % (participants.size - 1)) == 0
      end
  
      create_missing_games(missing_games, participants, first_is_home)
    end

  def end_of_game(game)
      if game.state == Game::WIN_FIRST
        ranking_lines.find_by_participant_id(game.first_participant_id).add_win(game.first_plus, game.first_minus)
        ranking_lines.find_by_participant_id(game.second_participant_id).add_lose(game.second_plus, game.second_minus)
      elsif game.state == Game::WIN_SECOND
        ranking_lines.find_by_participant_id(game.first_participant_id).add_lose(game.first_plus, game.first_minus)
        ranking_lines.find_by_participant_id(game.second_participant_id).add_win(game.second_plus, game.second_minus)
      elsif game.state == Game::DRAW
        ranking_lines.find_by_participant_id(game.first_participant_id).add_draw(game.first_plus, game.first_minus)
        ranking_lines.find_by_participant_id(game.second_participant_id).add_draw(game.second_plus, game.second_minus)
      end
    end

  def create_game(first_participant, second_participant, first_is_home = true)
      if first_is_home
        games.create(:first_participant_id => first_participant,
                     :second_participant_id => second_participant,
                     :participant_type => ranking.tournament.participants_type,
                     :best_of => ranking.best_of)
      else
        games.create(:first_participant_id => second_participant,
                     :second_participant_id => first_participant,
                     :participant_type => ranking.tournament.participants_type,
                     :best_of => ranking.best_of)
      end
  end

  def create_missing_games(missing_games, participants, first_is_home)
      until missing_games.empty? do
        # Generate the games
        0.upto(participants.size / 2 - 1) do |i|
          first_index = missing_games.index(participants[i])
          second_index = missing_games.index(participants[participants.size - 1 - i])
          if participants[i] != 0 and
              participants[participants.size - 1 - i] != 0 and
              first_index != nil and second_index != nil
            create_game(participants[i], participants[participants.size - 1 - i],
                        first_is_home)
            missing_games.delete_at(first_index)
            missing_games.delete_at((second_index > first_index) ? second_index - 1 : second_index)
          end
        end
        participants = rotate_participants(participants)
      end
  end

  # Rotate the table, fixing the first case
  #
  # Ex: 1 2 3 4 5 6
  #  -> 1 6 2 3 4 5
  def rotate_participants(participants)
      (participants.size - 1).downto(2) do |i|
        tmp = participants[i]
        participants[i] = participants[i - 1]
        participants[i - 1] = tmp
      end
      participants
  end

  # Build a table with all the participant_id
  # If there is an odd number of participants,
  # add a fake one to the table (participant_id == 0)
  def build_participants
      participants = []
      ranking_lines.each do |ranking_line|
        participants << ranking_line.participant_id
      end
  
      # If there is an odd number of participants, add a fake one
      participants << 0 if participants.size % 2 != 0
      participants
  end
end
