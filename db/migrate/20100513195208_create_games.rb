class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.integer :playable_id
      t.string :playable_type
      t.integer :first_participant_id
      t.integer :second_participant_id
      t.string :participant_type
      t.string :state
      t.datetime :starts_at
      t.datetime :ends_at
      t.integer :best_of

      t.timestamps
    end
  end

  def self.down
    drop_table :games
  end
end
