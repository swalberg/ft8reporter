Sequel.migration do
  change do
    add_index :spots, :observation_period_id
  end
end
