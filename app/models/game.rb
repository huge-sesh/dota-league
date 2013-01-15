class Game < ActiveRecord::Base
  require "trueskill"
  attr_accessible :state, :radiant_victory, :quality, :users, :positions
  has_many :positions
  has_many :users, :through => :positions

  #def users
  #  self.positions.map { |p| p.user }
  #end

  def radiant
    users.slice(0..5)
  end
  def dire
    users.slice(5..10)
  end
  
  def self.create_with_users(users)
    _radiant, _dire, _quality = TrueSkill.balance(users)
    game = Game.create(:quality => _quality)
    (_radiant + _dire).each do |user|
      Position.create(:user => user, :game => game)
      user.dequeue!
    end
    game.save!
    return game
  end

  def self.check_queue!
    users = User.where(:is_queued => true)
    if users.size >= 10
      return Game.create_with_users(users[0..9])
    end
    return false
  end
end
