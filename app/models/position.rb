class Position < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  attr_accessible :accept, :user, :game
end
