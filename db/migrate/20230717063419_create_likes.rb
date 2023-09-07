class CreateLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :likes do |t|
      t.integer :member_id, null: false
      t.integer :idea_id,   null: false

      t.timestamps
    end
  end
end
