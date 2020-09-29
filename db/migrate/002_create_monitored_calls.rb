Sequel.migration do
  up do
    create_table :monitored_calls do
      primary_key :id
      String :callsign
    end
  end

  down do
    drop_table :monitored_calls
  end
end
