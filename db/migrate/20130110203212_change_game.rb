class ChangeGame < ActiveRecord::Migration
  def up 
    (1..10).each do |n|
      add_column :games, ("p_%d_accept" % n).to_sym, :boolean
    end
    add_column :games, :state, :string, :default => "accepting"
    remove_column :games, :finished
  end

  def down
  end
end
