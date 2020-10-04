class Spot < Sequel::Model
  many_to_one :observation_period

  def to_a
    [ id, timestamp, sender, spotter, frequency, band, mode, range, bearing, lat, lon, snr, grid, region, dxcc, decoder, antenna ]
  end

  def to_feature
    {
      type: 'Feature',
      geometry: {
        type: 'Point',
        coordinates: [lon, lat]
      },
      properties: {
        band: band,
        name: spotter,
        sender: sender,
        snr: snr
      }
    }
  end

  def band
    return 0 unless frequency

    mhz = frequency / 1_000_000.0
    case mhz
    when 1.8..2.0
      160
    when 3.5..4.0
      80
    when 7.0..7.3
      40
    when 10..10.2
      30
    when 14.0..14.4
      20
    when 18..18.2
      17
    when 21..21.5
      15
    when 24.8..25
      12
    when 28..30
      10
    when 50..54
      6
    when 144..148
      2
    end
  end
end
