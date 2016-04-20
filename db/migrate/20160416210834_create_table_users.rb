class CreateTableUsers < ActiveRecord::Migration[5.0]
  def self.up
    create_table :users do |t|
      t.string :login,           null: false, default: ""
      t.string :email,           null: false, default: ""
      t.string :password_digest, null: false, default: ""

      t.string :authentication_token

      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :login,                unique: true
    add_index :users, :authentication_token, unique: true
  end

  def self.down
    drop_table :users
  end
end
