class CreateRankingLines < ActiveRecord::Migration
  def self.up
    create_table :ranking_lines do |t|
      t.integer :group_id
      t.integer :participant_id
      t.string :participant_type
      t.integer :points
      t.integer :win
      t.integer :draw
      t.integer :lose
      t.integer :plus
      t.integer :minus
      t.integer :diff

      t.timestamps
    end
  end

  def self.down
    drop_table :ranking_lines
  end
end
