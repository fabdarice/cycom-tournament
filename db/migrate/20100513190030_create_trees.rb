class CreateTrees < ActiveRecord::Migration
  def self.up
    create_table :trees do |t|
      t.integer :tournament_id
      t.string :tree_type
      t.string :state
      t.integer :best_of

      t.timestamps
    end
  end

  def self.down
    drop_table :trees
  end
end
