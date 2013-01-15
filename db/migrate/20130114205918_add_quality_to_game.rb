class AddQualityToGame < ActiveRecord::Migration
  def change
    add_column :games, :quality, :float
  end
end
