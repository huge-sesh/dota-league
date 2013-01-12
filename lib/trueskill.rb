module TrueSkill
  require "rubypython"
  RubyPython.start_from_virtualenv("lib/pyenv")
  @@python = RubyPython.import("trueskill")
  @@python.setup(:draw_probability => 0)
  def self.python
    @@python
  end

  def self.rating(user)
    @@python.Rating(user.mu, user.sigma)
  end

  def self.rate(radiant, dire, radiant_victory)
    victor = radiant_victory ? [1, 2] : [2, 1]
    users = [radiant, dire]
    ratings = @@python.rate([radiant.map {|user| rating(user)}, dire.map {|user| rating(user)}], victor)
    users.zip(ratings).each do |user, rating|
      user.mu    = rating.mu
      user.sigma = rating.sigma
    end
    return users
  end

  def self.quality(radiant, dire)
    users = [radiant, dire]
    @@python.quality([radiant.map {|user| rating(user)}, dire.map {|user| rating(user)}])
  end

  def self.balance(users)
    best_quality = 0
    radiant = nil
    dire = nil
    users.combination(5) do |_radiant|
      _dire = (users.to_set - _radiant.to_set).to_array
      _quality = quality(_radiant, _dire)
      if _quality > best_quality
        quality = _quality
        radiant = _radiant
        dire    = _dire
      end
    return [radiant, dire, quality]
    end
  end
end

