class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.integer :tournament_id
      t.integer :participant_id

      t.timestamps
    end
  end

  def self.down
    drop_table :subscriptions
  end
end
