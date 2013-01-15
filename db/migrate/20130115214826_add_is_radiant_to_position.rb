class AddIsRadiantToPosition < ActiveRecord::Migration
  def change
    add_column :positions, :is_radiant, :boolean
  end
end
