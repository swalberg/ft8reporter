Sequel.migration do
  up do
    create_table :spots do
      primary_key :id
      Timestamp :timestamp
      String :sender
      String :spotter
      Integer :frequency
      Integer :band
      String :mode
      Integer :range
      Integer :bearing
      Float :lat
      Float :lon
      Float :snr
      String :grid
      String :region
      String :dxcc
      String :decoder
      String :antenna
    end
  end

  down do
    drop_table :spots
  end
end
