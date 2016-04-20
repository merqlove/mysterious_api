class AddRoleToUser < ActiveRecord::Migration[5.0]
  def up
    add_column :users, :role, :integer, null: false, index: true
  end

  def down
    remove_column :users, :role
  end
end
