class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :title
      t.text :message
      t.string :icon
      t.boolean :read, default: false
      t.integer :user_id

      t.timestamps
    end
  end
end
