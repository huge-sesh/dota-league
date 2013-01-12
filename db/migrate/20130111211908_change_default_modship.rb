class ChangeDefaultModship < ActiveRecord::Migration
  def up
    change_column_default :users, :is_admin, false
    change_column_default :users, :is_mod, false
  end

  def down
  end
end
