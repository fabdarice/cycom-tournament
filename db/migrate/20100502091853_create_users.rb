class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :nickname
      t.string :password_hash
      t.string :address
      t.string :zip_code, :limit => 10
      t.date :birthdate
      t.string :country
      t.string :email
      t.string :phone, :limit => 20
      t.string :sex, :limit => 1
      t.boolean :admin, :default => false
      t.string :city
      t.string :password_salt, :limit => 20
      t.string :cookie_hash

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
