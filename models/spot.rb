class Spot < Sequel::Model
  many_to_one :observation_period

end
