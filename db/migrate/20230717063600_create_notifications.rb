class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.integer :idea_id
      t.integer :visitor_id, foreign_key: { to_table: :members }, null: false
      t.integer :visited_id, foreign_key: { to_table: :members }, null: false
      t.integer :comment_id
      t.integer :room_id
      t.integer :message_id
      t.string  :action
      t.boolean :checked, default: false, null: false


      t.timestamps
    end
  end
end
