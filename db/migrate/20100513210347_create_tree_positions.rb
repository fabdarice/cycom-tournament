class CreateTreePositions < ActiveRecord::Migration
  def self.up
    create_table :tree_positions do |t|
      t.integer :tree_id
      t.integer :participant_id
      t.string :participant_type
      t.integer :position
      t.boolean :special

      t.timestamps
    end
  end

  def self.down
    drop_table :tree_positions
  end
end
