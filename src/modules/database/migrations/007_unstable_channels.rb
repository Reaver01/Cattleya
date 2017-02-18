Sequel.migration do
  up do
    create_table(:unstable_channels) do
      primary_key :id
      Integer :channel_id
      TrueClass :unstable, default: false
    end
  end

  down do
    drop_table(:unstable_channels)
  end
end
