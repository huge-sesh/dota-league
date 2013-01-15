class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.references :user
      t.references :game
      t.boolean :accept

      t.timestamps
    end
    remove_column :games, :p_1_id, :p_2_id, :p_3_id, :p_4_id, :p_5_id, :p_6_id, :p_7_id, :p_8_id, :p_9_id, :p_10_id
    remove_column :games, :p_1_accept, :p_2_accept, :p_3_accept, :p_4_accept, :p_5_accept, :p_6_accept, :p_7_accept, :p_8_accept, :p_9_accept, :p_10_accept
    add_index :positions, :user_id
    add_index :positions, :game_id
  end
end
