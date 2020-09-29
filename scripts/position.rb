require 'maidenhead'
require 'haversine'

class Position
  def initialize(grid)
    @grid = grid
    @coords = Maidenhead.to_latlon(grid)
  end

  def lat
    @coords[0]
  end

  def lon
    @coords[1]
  end

  def lat_r
    lat * Math::PI / 180.0
  end

  def lon_r
    lon * Math::PI / 180.0
  end

  def to_s
    "lat = #{lat} lon = #{lon}"
  end

  def distance_to(target)
    d = Haversine.distance(lat, lon, target.lat, target.lon)
    d.to_km.round
  end

  def bearing_to(target)
    x = Math.cos(target.lat_r) * Math.sin(target.lon_r - lon_r)
    y = Math.cos(lat_r) * Math.sin(target.lat_r) - Math.sin(lat_r) * Math.cos(target.lat_r) * Math.cos(target.lon_r - lon_r)

    theta = Math.atan2(x, y) # radians
    (theta * 180.0/Math::PI + 360.0).round % 360  # degrees
  end
end
