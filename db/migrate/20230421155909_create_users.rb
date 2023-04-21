class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.boolean :is_admin, null: false, default: false
      t.boolean :is_enabled, null: false, default: true
      t.timestamps
    end
  end
end
