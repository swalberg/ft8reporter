require 'sequel'
require 'json'
require 'padrino'
require 'open-uri'
require_relative '../config/database'
require_relative 'position'
require_relative '../models/spot'
require_relative '../models/monitored_call'

def find_spots_for(call)
  uri = URI.parse "https://pskreporter.info/cgi-bin/pskquery5.pl?encap=0&callback=doNothing&statistics=1&noactive=1&nolocator=1&flowStartSeconds=-900&senderCallsign=#{call}&lastDuration=1089"
  raw = uri.read
  puts raw

  raw.gsub!(/^doNothing\(/m, '')
  raw.gsub!(/^\);$/m, '')

  api = JSON.parse(raw)

  receptions = api['receptionReport']
  reporters = api['activeReceiver']

  stations = []

  receptions.each do |r|
    from = Position.new(r['senderLocator'])
    to = Position.new(r['receiverLocator'])

    b = from.bearing_to(to)
    report = { mode: r['mode'], frequency: r['frequency'], call: r['receiverCallsign'], range: from.distance_to(to), bearing: b, lat: to.lat, lon: to.lon, snr: r['sNR'], grid: r['receiverLocator']}
    reporter = reporters.find { |i| i['callsign'] == r['receiverCallsign'] }
    if reporter
      report.merge!({ region: reporter['region'], dxcc: reporter['DXCC'], decoder: reporter['decoderSoftware'], antenna: reporter['antennaInformation'] })
    end
    stations.push report
  end

  puts "Heard from #{stations.count} stations"
  far = stations.max_by { |m| m[:range] }
  puts "Furthest station is #{far}"
  stations.each do |s|
    spot = Spot.new(
      timestamp: Time.now,
      sender: call,
      spotter: s[:call],
      frequency: s[:frequency],
      mode: s[:mode],
      range: s[:range],
      bearing: s[:bearing],
      lat: s[:lat],
      lon: s[:lon],
      snr: s[:snr],
      grid: s[:grid],
      region: s[:region],
      dxcc: s[:dxcc],
      decoder: s[:decoder],
      antenna: s[:antenna]
    )
    spot.save
  end
end

MonitoredCall.all do |call|
  sleep 10
  puts "Checking #{call.callsign}"
  find_spots_for call.callsign
rescue OpenURI::HTTPError => e
  puts "Error! #{e}"
end

