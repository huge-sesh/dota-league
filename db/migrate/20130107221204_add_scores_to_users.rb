class AddScoresToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mu, :float
    add_column :users, :sigma, :float
    add_column :users, :is_admin, :boolean
    add_column :users, :is_mod, :boolean
    add_column :users, :username, :string
  end
end
