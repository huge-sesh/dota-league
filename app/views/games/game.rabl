object @game

attributes :quality, :state, :radiant_victory, :password, :id
[:radiant, :dire, :waiting, :accepted].each do |sym|
  node sym do
    @game.send(sym).map { |u| u.username }
  end
end
