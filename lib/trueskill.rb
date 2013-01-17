module TrueSkill
  require "rubypython"
  require "active_support/all"
  RubyPython.start_from_virtualenv("lib/pyenv")
  @@python = RubyPython.import("trueskill")
  @@python.setup(:draw_probability => 0)
  def self.python
    @@python
  end

  def self.rating(user)
    @@python.Rating(user.mu, user.sigma)
  end

  def self.rate!(radiant, dire, radiant_victory)
    victor = radiant_victory ? [1, 2] : [2, 1]
    users = [radiant, dire]
    ratings = @@python.rate([radiant.map {|user| rating(user)}, dire.map {|user| rating(user)}], victor)
    (radiant + dire).zip(ratings[0] + ratings[1]).each do |user, rating|
      user.delta_mu = rating.mu - user.mu
      user.delta_sigma = rating.sigma - user.sigma
      user.mu    = rating.mu
      user.sigma = rating.sigma
      user.save
    end
  end

  def self.quality(radiant, dire)
    users = [radiant, dire]
    _quality = @@python.quality([radiant.map {|user| rating(user)}, dire.map {|user| rating(user)}]).to_s.to_f
    p ['received quality:', _quality]
    return _quality
  end

  def self.balance(users)
    best_quality = 0
    radiant = nil
    dire = nil
    users.combination(5) do |_radiant|
      _dire = (users.to_set - _radiant.to_set).to_a
      _quality = quality(_radiant, _dire)
      if _quality > best_quality
        best_quality = _quality
        radiant = _radiant
        dire    = _dire
        p ['best_quality:', best_quality]
      end
    return [radiant, dire, best_quality]
    end
  end
end

