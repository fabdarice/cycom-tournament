class CreateTeams < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.string :name
      t.string :tag
      t.string :website
      t.string :email
      t.string :irc
      t.string :motto
      t.string :nationality
      t.string :password_hash
      t.string :password_salt
      t.integer :manager_id

      t.timestamps
    end
  end

  def self.down
    drop_table :teams
  end
end
