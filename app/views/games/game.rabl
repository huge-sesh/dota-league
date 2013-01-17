object @game

attributes :quality, :state, :radiant_victory, :password, :id
child :radiant do
  attributes :username
end
child :dire do
  attributes :username
end
child :accepted do
  attributes :username
end
child :waiting do
  attributes :username
end
