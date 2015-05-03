class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :game_id
      t.string :file

      t.timestamps null: false
    end
  end
end
