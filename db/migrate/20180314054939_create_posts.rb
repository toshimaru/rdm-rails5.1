class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.references :user, foreign_key: true, null: false
      t.string :title
      t.text :content
      t.integer :favorite_count, null: false, default: 0

      t.timestamps
    end
  end
end
