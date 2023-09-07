class CreateRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :relationships do |t|
      t.integer :follower_id, foreign_key: { to_table: :members }
      t.integer :followed_id, foreign_key: { to_table: :members }

      t.timestamps
    end
  end
end
