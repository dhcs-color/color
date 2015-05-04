class AddColorsToRankings < ActiveRecord::Migration
  def change
    add_column :rankings, :color1, :string
    add_column :rankings, :color2, :string
    add_column :rankings, :color3, :string
    add_column :rankings, :color4, :string
  end
end
