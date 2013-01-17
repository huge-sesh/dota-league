class Game < ActiveRecord::Base
  require "trueskill"
  attr_accessible :state, :radiant_victory, :quality, :users, :positions
  has_many :positions
  has_many :users, :through => :positions
  after_destroy :requeue_users

  def radiant
    positions.select{|p| p.is_radiant}.map{|p| p.user}
  end
  def dire
    positions.select{|p| !p.is_radiant}.map{|p| p.user}
  end
  def accepted
    positions.select{|p| p.accept}.map{|p| p.user}
  end
  def waiting
    positions.select{|p| !p.accept}.map{|p| p.user}
  end
  
  def self.create_with_users(users)
    _radiant, _dire, _quality = TrueSkill.balance(users)
    game = Game.create(:quality => _quality)
    (_radiant + _dire).each do |user|
      Position.create(:user => user, :game => game, :is_radiant => _radiant.include?(user))
      user.dequeue!
    end
    game.save
    return game
  end

  def report!(radiant_victory)
    self.radiant_victory = radiant_victory
    TrueSkill.rate(self.radiant, self.dire, radiant_victory)
    self.save
    return self
  end

  def self.check_queue!
    users = User.where(:is_queued => true)
    if users.size >= 10
      return Game.create_with_users(users[0..9])
    end
    return false
  end

  def check_accepts!
    if self.accepted.length == 10
      self.state = 'active'
      self.save
      return self
    end
    return self
  end

  def requeue_users
    self.users.each do |u|
      u.is_queued = true
      u.save
    end
  end
  

end
