class RemoveImageFromGame < ActiveRecord::Migration
  def change
    remove_column :games, :image_path, :string
  end
end
