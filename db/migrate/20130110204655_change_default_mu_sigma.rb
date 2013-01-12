class ChangeDefaultMuSigma < ActiveRecord::Migration
  def up
    change_column_default :users, :mu, 25.0
    change_column_default :users, :sigma, 25.0/3.0
  end

  def down
  end
end
