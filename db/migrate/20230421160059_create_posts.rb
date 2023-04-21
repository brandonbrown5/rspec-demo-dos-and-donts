class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.references :user, null: false
      t.string :title
      t.string :description
      t.boolean :is_published, null: false, default: false
      t.boolean :is_important, null: false, default: false
      t.timestamps
    end
  end
end
