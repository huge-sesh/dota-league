object @ratings

attributes :quality, :radiant_victory, :id
child :radiant do
  attributes :username, :mu, :sigma, :delta_mu, :delta_sigma
end
child :dire do
  attributes :username, :mu, :sigma, :delta_mu, :delta_sigma
end
