class CreateIdeas < ActiveRecord::Migration[6.1]
  def change
    create_table :ideas do |t|
      t.integer :member_id
      t.string :title, null: false
      t.text   :body

      t.timestamps
    end
  end
end
