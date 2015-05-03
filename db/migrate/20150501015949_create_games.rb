class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :from_user_id
      t.integer :to_user_id
      t.string :image_path
      t.boolean :is_accepted

      t.timestamps null: false
    end
  end
end
