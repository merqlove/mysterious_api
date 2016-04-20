class CreatePostFollows < ActiveRecord::Migration[5.0]
  def up
    create_table :post_follows do |t|
      t.references :post, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps
    end
    add_index :post_follows, [:post_id, :user_id], unique: true
  end

  def down
      drop_table :post_follows
  end
end
