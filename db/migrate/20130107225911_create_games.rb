class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.references :p_1
      t.references :p_2
      t.references :p_3
      t.references :p_4
      t.references :p_5
      t.references :p_6
      t.references :p_7
      t.references :p_8
      t.references :p_9
      t.references :p_10
      t.boolean :finished
      t.boolean :radiant_victory
      t.timestamps
    end
  end
end
