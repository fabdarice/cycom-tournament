class CreateTournaments < ActiveRecord::Migration
  def self.up
    create_table :tournaments do |t|
      t.integer :event_id
      t.integer :branch_id
      t.string :name
      t.integer :max_participants
      t.string :participants_type
      t.datetime :starts_at
      t.datetime :ends_at
      t.string :state

      t.timestamps
    end
  end

  def self.down
    drop_table :tournaments
  end
end
