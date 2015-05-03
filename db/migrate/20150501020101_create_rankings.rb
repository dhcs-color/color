class CreateRankings < ActiveRecord::Migration
  def change
    create_table :rankings do |t|
      t.integer :game_id
      t.text :user_colors, array: true, default: []
      t.timestamps null: false
    end
  end
end
