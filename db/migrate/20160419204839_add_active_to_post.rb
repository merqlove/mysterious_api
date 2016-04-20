class AddActiveToPost < ActiveRecord::Migration[5.0]
  def up
    add_column :posts, :status, :integer
    add_index :posts, :status
  end

  def down
    remove_column :posts, :status
  end
end
