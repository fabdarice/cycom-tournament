class CreateRankings < ActiveRecord::Migration
  def self.up
    create_table :rankings do |t|
      t.integer :tournament_id
      t.integer :round
      t.integer :win_points
      t.integer :draw_points
      t.integer :lose_points
      t.integer :groups_number
      t.integer :qualified
      t.integer :games_number
      t.string :state
      t.integer :best_of

      t.timestamps
    end
  end

  def self.down
    drop_table :rankings
  end
end
