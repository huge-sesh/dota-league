class AddIsQueuedToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_queued, :boolean, :default => false
  end
end
