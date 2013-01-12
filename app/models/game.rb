class Game < ActiveRecord::Base
  require "trueskill"
  (1..10).each do |n|
    has_one ("p_%d" % n).to_sym, :class_name => "User"
    attr_accessible ("p_%d_accept" % n).to_sym
  end
  attr_accessible :state, :radiant_victory

  def players
    return [self.p_1, self.p_2, self.p_3, self.p_4, self.p_5, 
      self.p_6, self.p_7, self.p_8, self.p_9, self.p_10]
  end
  def set_players!(users)
    radiant, dire, self.quality = TrueSkill.balance(users)
    self.p_1, self.p_2, self.p_3, self.p_4, self.p_5  = radiant
    self.p_6, self.p_7, self.p_8, self.p_9, self.p_10 = dire 
    self.save
  end

  def self.check_queue
    users = User.where(:is_queued => true)
    if users.size >= 10
      users = users[0..9]
      game = Game.new()
      users.each do |user|
        user.dequeue!
      end
      game.set_players!(users)
      game.save
      return true
    end
    return false
  end
end
