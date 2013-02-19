object @game

attributes :quality, :radiant_victory, :id
[:radiant, :dire].each do |sym|
  node sym do
    @ratings.send(sym).map do |u|
      attributes :username, :mu, :sigma, :delta_mu, :delta_sigma
    end
  end
end
