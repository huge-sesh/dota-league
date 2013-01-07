class Game < ActiveRecord::Base
  (1..10).each do |n|
    has_one :"p_%d" % n, :class_name => "User"
  end
  attr_accessible :finished, :radiant_victory

  def players
    return [self.p_1, self.p_2, self.p_3, self.p_4, self.p_5, 
      self.p_6, self.p_7, self.p_8, self.p_9, self.p_10]
  end

end
