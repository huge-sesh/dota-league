class AddPasswordToGame < ActiveRecord::Migration
  def change
    add_column :games, :password, :string, :default => 'cute'
  end
end
