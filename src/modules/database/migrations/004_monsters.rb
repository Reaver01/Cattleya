Sequel.migration do
  up do
    create_table(:monsters) do
      primary_key :id
      Integer :hp
      String :color
      String :icon
      String :name
      TrueClass :trapped_by_shock
      TrueClass :trapped_by_fall
    end
  end

  down do
    drop_table(:monsters)
  end
end
