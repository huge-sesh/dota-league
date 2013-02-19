class DontIndexEmails < ActiveRecord::Migration
  def up
    remove_index :users, :email
  end

  def down
  end
end
