class ChangeAcceptDefault < ActiveRecord::Migration
  def up
    change_column :positions, :accept, :boolean, :default => false
  end

  def down
  end
end
