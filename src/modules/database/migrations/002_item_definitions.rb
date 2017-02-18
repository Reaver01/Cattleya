Sequel.migration do
  up do
    create_table(:item_definitions) do
      primary_key :id
      String :name
      String :image
      Integer :price
      TrueClass :can_throw
    end
  end

  down do
    drop_table(:item_definitions)
  end
end
