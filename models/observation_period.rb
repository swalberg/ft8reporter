class ObservationPeriod < Sequel::Model
  one_to_many :spots

end
