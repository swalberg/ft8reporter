Sequel.migration do
  up do
    create_table :observation_periods do
      primary_key :id
      Timestamp :run_start
      Timestamp :run_end
    end
  end

  down do
    drop_table :observation_periods
  end
end
