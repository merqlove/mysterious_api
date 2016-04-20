class CreatePosts < ActiveRecord::Migration[5.0]
  def up
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.string :meta_keywords
      t.string :meta_desc
      t.references :user, index: true, foreign_key: true

      t.timestamps
    end
  end

  def down
    drop_table :posts
  end
end
