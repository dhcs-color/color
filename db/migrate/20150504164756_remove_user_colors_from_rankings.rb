class RemoveUserColorsFromRankings < ActiveRecord::Migration
  def change
    remove_column :rankings, :user_colors, :text
  end
end
