class CreateRounds < ActiveRecord::Migration
  def self.up
    create_table :rounds do |t|
      t.integer :game_id
      t.integer :game_round
      t.integer :first_score
      t.integer :second_score
      t.datetime :starts_at
      t.datetime :ends_at
      t.string :state

      t.timestamps
    end
  end

  def self.down
    drop_table :rounds
  end
end
