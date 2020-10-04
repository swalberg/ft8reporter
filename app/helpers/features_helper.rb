class FeaturesHelper
  def self.create_feature_collection(observation)
    spots = Spot.where(observation_period_id: observation.id)
    {
      type: 'FeatureCollection',
      features: spots.map(&:to_feature)

    }.to_json
  end
end
