Sequel.migration do
  up do
    alter_table :spots do
      add_column :observation_period_id, Integer
    end
  end

  down do
    alter_table :spots do
      drop_column :observation_period_id
    end
  end
end
