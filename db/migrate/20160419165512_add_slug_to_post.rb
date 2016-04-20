class AddSlugToPost < ActiveRecord::Migration[5.0]
  def up
    add_column :posts, :slug, :string
    add_index :posts, :slug
  end

  def down
    remove_column :posts, :slug
  end
end
